# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: apache-2.eclass
# @MAINTAINER:
# polynomial-c@gentoo.org
# @BLURB: Provides a common set of functions for apache-2.x ebuilds
# @DESCRIPTION:
# This eclass handles apache-2.x ebuild functions such as LoadModule generation
# and inter-module dependency checking.

inherit autotools eutils flag-o-matic multilib ssl-cert user toolchain-funcs versionator

[[ ${CATEGORY}/${PN} != www-servers/apache ]] \
	&& die "Do not use this eclass with anything else than www-servers/apache ebuilds!"

case ${EAPI:-0} in
	0|1|2|3|4)
		die "This eclass requires >=EAPI-5"
	;;
esac

# settings which are version specific go in here:
case $(get_version_component_range 1-2) in
	2.4)
		DEFAULT_MPM_THREADED="event" #509922
		RDEPEND=">=dev-libs/apr-1.5.1
			!www-apache/mod_macro" #492578 #477702
	;;
	*)
		DEFAULT_MPM_THREADED="worker"
		RDEPEND=">=dev-libs/apr-1.4.5" #368651
	;;
esac

# ==============================================================================
# INTERNAL VARIABLES
# ==============================================================================

# @ECLASS-VARIABLE: GENTOO_PATCHNAME
# @DESCRIPTION:
# This internal variable contains the prefix for the patch tarball.
# Defaults to the full name and version (including revision) of the package.
# If you want to override this in an ebuild, use:
# ORIG_PR="(revision of Gentoo stuff you want)"
# GENTOO_PATCHNAME="gentoo-${PN}-${PV}${ORIG_PR:+-${ORIG_PR}}"
[[ -n "$GENTOO_PATCHNAME" ]] || GENTOO_PATCHNAME="gentoo-${PF}"

# @ECLASS-VARIABLE: GENTOO_PATCHDIR
# @DESCRIPTION:
# This internal variable contains the working directory where patches and config
# files are located.
# Defaults to the patchset name appended to the working directory.
[[ -n "$GENTOO_PATCHDIR" ]] || GENTOO_PATCHDIR="${WORKDIR}/${GENTOO_PATCHNAME}"

# @VARIABLE: GENTOO_DEVELOPER
# @DESCRIPTION:
# This variable needs to be set in the ebuild and contains the name of the
# gentoo developer who created the patch tarball

# @VARIABLE: GENTOO_PATCHSTAMP
# @DESCRIPTION:
# This variable needs to be set in the ebuild and contains the date the patch
# tarball was created at in YYYYMMDD format

# @VARIABLE: GENTOO_PATCH_A
# @DESCRIPTION:
# This variable should contain the entire filename of patch tarball.
# Defaults to the name of the patchset, with a datestamp.
[[ -n "$GENTOO_PATCH_A" ]] || GENTOO_PATCH_A="${GENTOO_PATCHNAME}-${GENTOO_PATCHSTAMP}.tar.bz2"

SRC_URI="mirror://apache/httpd/httpd-${PV}.tar.bz2
	https://dev.gentoo.org/~${GENTOO_DEVELOPER}/dist/apache/${GENTOO_PATCH_A}"

# @VARIABLE: IUSE_MPMS_FORK
# @DESCRIPTION:
# This variable needs to be set in the ebuild and contains a list of forking
# (i.e.  non-threaded) MPMs

# @VARIABLE: IUSE_MPMS_THREAD
# @DESCRIPTION:
# This variable needs to be set in the ebuild and contains a list of threaded
# MPMs

# @VARIABLE: IUSE_MODULES
# @DESCRIPTION:
# This variable needs to be set in the ebuild and contains a list of available
# built-in modules

IUSE_MPMS="${IUSE_MPMS_FORK} ${IUSE_MPMS_THREAD}"
IUSE="${IUSE} debug doc ldap selinux ssl static suexec threads"

for module in ${IUSE_MODULES} ; do
	IUSE="${IUSE} apache2_modules_${module}"
done

for mpm in ${IUSE_MPMS} ; do
	IUSE="${IUSE} apache2_mpms_${mpm}"
done

DEPEND="dev-lang/perl
	=dev-libs/apr-1*
	=dev-libs/apr-util-1*[ldap?]
	dev-libs/libpcre
	apache2_modules_deflate? ( sys-libs/zlib )
	apache2_modules_mime? ( app-misc/mime-types )
	ldap? ( =net-nds/openldap-2* )
	ssl? ( >=dev-libs/openssl-0.9.8m:0= )
	!=www-servers/apache-1*"
RDEPEND+=" ${DEPEND}
	selinux? ( sec-policy/selinux-apache )"
PDEPEND="~app-admin/apache-tools-${PV}"

S="${WORKDIR}/httpd-${PV}"

# ==============================================================================
# INTERNAL FUNCTIONS
# ==============================================================================

# @ECLASS-VARIABLE: MY_MPM
# @DESCRIPTION:
# This internal variable contains the selected MPM after a call to setup_mpm()

# @FUNCTION: setup_mpm
# @DESCRIPTION:
# This internal function makes sure that only one of APACHE2_MPMS was selected
# or a default based on USE=threads is selected if APACHE2_MPMS is empty
setup_mpm() {
	MY_MPM=""
	for x in ${IUSE_MPMS} ; do
		if use apache2_mpms_${x} ; then
			if [[ -z "${MY_MPM}" ]] ; then
				MY_MPM=${x}
				elog
				elog "Selected MPM: ${MY_MPM}"
				elog
			else
				eerror "You have selected more then one mpm USE-flag."
				eerror "Only one MPM is supported."
				die "more then one mpm was specified"
			fi
		fi
	done

	if [[ -z "${MY_MPM}" ]] ; then
		if use threads ; then
			MY_MPM=${DEFAULT_MPM_THREADED}
			elog
			elog "Selected default threaded MPM: ${MY_MPM}"
			elog
		else
			MY_MPM=prefork
			elog
			elog "Selected default MPM: ${MY_MPM}"
			elog
		fi
	fi

	if has ${MY_MPM} ${IUSE_MPMS_THREAD} && ! use threads ; then
		eerror "You have selected a threaded MPM but USE=threads is disabled"
		die "invalid use flag combination"
	fi

	if has ${MY_MPM} ${IUSE_MPMS_FORK} && use threads ; then
		eerror "You have selected a non-threaded MPM but USE=threads is enabled"
		die "invalid use flag combination"
	fi
}

# @VARIABLE: MODULE_CRITICAL
# @DESCRIPTION:
# This variable needs to be set in the ebuild and contains a space-separated
# list of modules critical for the default apache. A user may still
# disable these modules for custom minimal installation at their own risk.

# @FUNCTION: check_module_critical
# @DESCRIPTION:
# This internal function warns the user about modules critical for the default
# apache configuration.
check_module_critical() {
	local unsupported=0

	for m in ${MODULE_CRITICAL} ; do
		if ! has ${m} ${MY_MODS[@]} ; then
			ewarn "Module '${m}' is required in the default apache configuration."
			unsupported=1
		fi
	done

	if [[ ${unsupported} -ne 0 ]] ; then
		ewarn
		ewarn "You have disabled one or more required modules"
		ewarn "for the default apache configuration."
		ewarn "Although this is not an error, please be"
		ewarn "aware that this setup is UNSUPPORTED."
		ewarn
	fi
}

# @VARIABLE: MODULE_DEPENDS
# @DESCRIPTION:
# This variable needs to be set in the ebuild and contains a space-separated
# list of dependency tokens each with a module and the module it depends on
# separated by a colon

# @FUNCTION: check_module_depends
# @DESCRIPTION:
# This internal function makes sure that all inter-module dependencies are
# satisfied with the current module selection
check_module_depends() {
	local err=0

	for m in ${MY_MODS[@]} ; do
		for dep in ${MODULE_DEPENDS} ; do
			if [[ "${m}" == "${dep%:*}" ]] ; then
				if ! use apache2_modules_${dep#*:} ; then
					eerror "Module '${m}' depends on '${dep#*:}'"
					err=1
				fi
			fi
		done
	done

	if [[ ${err} -ne 0 ]] ; then
		die "invalid use flag combination"
	fi
}

# @ECLASS-VARIABLE: MY_CONF
# @DESCRIPTION:
# This internal variable contains the econf options for the current module
# selection after a call to setup_modules()

# @ECLASS-VARIABLE: MY_MODS
# @DESCRIPTION:
# This internal variable contains a sorted, space separated list of currently
# selected modules after a call to setup_modules()

# @FUNCTION: setup_modules
# @DESCRIPTION:
# This internal function selects all built-in modules based on USE flags and
# APACHE2_MODULES USE_EXPAND flags
setup_modules() {
	local mod_type=

	if use static ; then
		mod_type="static"
	else
		mod_type="shared"
	fi

	MY_CONF=( --enable-so=static )
	MY_MODS=()

	if use ldap ; then
		MY_CONF+=( --enable-authnz_ldap=${mod_type} --enable-ldap=${mod_type} )
		MY_MODS+=( ldap authnz_ldap )
	else
		MY_CONF+=( --disable-authnz_ldap --disable-ldap )
	fi

	if use ssl ; then
		MY_CONF+=( --with-ssl="${EPREFIX}"/usr --enable-ssl=${mod_type} )
		MY_MODS+=( ssl )
	else
		MY_CONF+=( --without-ssl --disable-ssl )
	fi

	if use suexec ; then
		elog "You can manipulate several configure options of suexec"
		elog "through the following environment variables:"
		elog
		elog " SUEXEC_SAFEPATH: Default PATH for suexec (default: '${EPREFIX}/usr/local/bin:${EPREFIX}/usr/bin:${EPREFIX}/bin')"
		elog "  SUEXEC_LOGFILE: Path to the suexec logfile (default: '${EPREFIX}/var/log/apache2/suexec_log')"
		elog "   SUEXEC_CALLER: Name of the user Apache is running as (default: apache)"
		elog "  SUEXEC_DOCROOT: Directory in which suexec will run scripts (default: '${EPREFIX}/var/www')"
		elog "   SUEXEC_MINUID: Minimum UID, which is allowed to run scripts via suexec (default: 1000)"
		elog "   SUEXEC_MINGID: Minimum GID, which is allowed to run scripts via suexec (default: 100)"
		elog "  SUEXEC_USERDIR: User subdirectories (like /home/user/html) (default: public_html)"
		elog "    SUEXEC_UMASK: Umask for the suexec process (default: 077)"
		elog

		MY_CONF+=( --with-suexec-safepath="${SUEXEC_SAFEPATH:-${EPREFIX}/usr/local/bin:${EPREFIX}/usr/bin:${EPREFIX}/bin}" )
		MY_CONF+=( --with-suexec-logfile="${SUEXEC_LOGFILE:-${EPREFIX}/var/log/apache2/suexec_log}" )
		MY_CONF+=( --with-suexec-bin="${EPREFIX}/usr/sbin/suexec" )
		MY_CONF+=( --with-suexec-userdir=${SUEXEC_USERDIR:-public_html} )
		MY_CONF+=( --with-suexec-caller=${SUEXEC_CALLER:-apache} )
		MY_CONF+=( --with-suexec-docroot="${SUEXEC_DOCROOT:-${EPREFIX}/var/www}" )
		MY_CONF+=( --with-suexec-uidmin=${SUEXEC_MINUID:-1000} )
		MY_CONF+=( --with-suexec-gidmin=${SUEXEC_MINGID:-100} )
		MY_CONF+=( --with-suexec-umask=${SUEXEC_UMASK:-077} )
		MY_CONF+=( --enable-suexec=${mod_type} )
		MY_MODS+=( suexec )
	else
		MY_CONF+=( --disable-suexec )
	fi

	for x in ${IUSE_MODULES} ; do
		if use apache2_modules_${x} ; then
			MY_CONF+=( --enable-${x}=${mod_type} )
			MY_MODS+=( ${x} )
		else
			MY_CONF+=( --disable-${x} )
		fi
	done

	# sort and uniquify MY_MODS
	MY_MODS=( $(echo ${MY_MODS[@]} | tr ' ' '\n' | sort -u) )
	check_module_depends
	check_module_critical
}

# @VARIABLE: MODULE_DEFINES
# @DESCRIPTION:
# This variable needs to be set in the ebuild and contains a space-separated
# list of tokens each mapping a module to a runtime define which can be
# specified in APACHE2_OPTS in /etc/conf.d/apache2 to enable this particular
# module.

# @FUNCTION: generate_load_module
# @DESCRIPTION:
# This internal function generates the LoadModule lines for httpd.conf based on
# the current module selection and MODULE_DEFINES
generate_load_module() {
	local endit=0 mod_lines= mod_dir="${ED}/usr/$(get_libdir)/apache2/modules"

	if use static; then
		sed -i -e "/%%LOAD_MODULE%%/d" \
			"${GENTOO_PATCHDIR}"/conf/httpd.conf
		return
	fi

	for m in ${MY_MODS[@]} ; do
		if [[ -e "${mod_dir}/mod_${m}.so" ]] ; then
			for def in ${MODULE_DEFINES} ; do
				if [[ "${m}" == "${def%:*}" ]] ; then
					mod_lines="${mod_lines}\n<IfDefine ${def#*:}>"
					endit=1
				fi
			done

			mod_lines="${mod_lines}\nLoadModule ${m}_module modules/mod_${m}.so"

			if [[ ${endit} -ne 0 ]] ; then
				mod_lines="${mod_lines}\n</IfDefine>"
				endit=0
			fi
		fi
	done

	sed -i -e "s:%%LOAD_MODULE%%:${mod_lines}:" \
		"${GENTOO_PATCHDIR}"/conf/httpd.conf
}

# @FUNCTION: check_upgrade
# @DESCRIPTION:
# This internal function checks if the previous configuration file for built-in
# modules exists in ROOT and prevents upgrade in this case. Users are supposed
# to convert this file to the new APACHE2_MODULES USE_EXPAND variable and remove
# it afterwards.
check_upgrade() {
	if [[ -e "${EROOT}"etc/apache2/apache2-builtin-mods ]]; then
		eerror "The previous configuration file for built-in modules"
		eerror "(${EROOT}etc/apache2/apache2-builtin-mods) exists on your"
		eerror "system."
		eerror
		eerror "Please read https://www.gentoo.org/doc/en/apache-upgrading.xml"
		eerror "for detailed information how to convert this file to the new"
		eerror "APACHE2_MODULES USE_EXPAND variable."
		eerror
		die "upgrade not possible with existing ${ROOT}etc/apache2/apache2-builtin-mods"
	fi
}

# ==============================================================================
# EXPORTED FUNCTIONS
# ==============================================================================

# @FUNCTION: apache-2_pkg_setup
# @DESCRIPTION:
# This function selects built-in modules, the MPM and other configure options,
# creates the apache user and group and informs about CONFIG_SYSVIPC being
# needed (we don't depend on kernel sources and therefore cannot check).
apache-2_pkg_setup() {
	check_upgrade

	# setup apache user and group
	enewgroup apache 81
	enewuser apache 81 -1 /var/www apache

	setup_mpm
	setup_modules

	if use debug; then
		MY_CONF+=( --enable-maintainer-mode --enable-exception-hook )
	fi

	elog "Please note that you need SysV IPC support in your kernel."
	elog "Make sure CONFIG_SYSVIPC=y is set."
	elog

	if use userland_BSD; then
		elog "On BSD systems you need to add the following line to /boot/loader.conf:"
		elog "  accf_http_load=\"YES\""
		elog
	fi
}

# @FUNCTION: apache-2_src_prepare
# @DESCRIPTION:
# This function applies patches, configures a custom file-system layout and
# rebuilds the configure scripts.
apache-2_src_prepare() {
	#fix prefix in conf files etc (bug #433736)
	use !prefix || sed -e "s@/\(usr\|var\|etc\|run\)/@${EPREFIX}&@g" \
		-i "${GENTOO_PATCHDIR}"/conf/httpd.conf "${GENTOO_PATCHDIR}"/scripts/* \
		"${GENTOO_PATCHDIR}"/docs/*.example "${GENTOO_PATCHDIR}"/patches/*.layout \
		"${GENTOO_PATCHDIR}"/init/* "${GENTOO_PATCHDIR}"/conf/vhosts.d/* \
		"${GENTOO_PATCHDIR}"/conf/modules.d/* || die

	# 03_all_gentoo-apache-tools.patch injects -Wl,-z,now, which is not a good
	# idea for everyone
	case ${CHOST} in
		*-linux-gnu|*-solaris*|*-freebsd*)
			# do nothing, these use GNU binutils
			:
		;;
		*-darwin*)
			sed -i -e 's/-Wl,-z,now/-Wl,-bind_at_load/g' \
				"${GENTOO_PATCHDIR}"/patches/03_all_gentoo_apache-tools.patch
		;;
		*)
			# patch it out to be like upstream
			sed -i -e 's/-Wl,-z,now//g' \
				"${GENTOO_PATCHDIR}"/patches/03_all_gentoo_apache-tools.patch
		;;
	esac

	# Use correct multilib libdir in gentoo patches
	sed -i -e "s:/usr/lib:/usr/$(get_libdir):g" \
		"${GENTOO_PATCHDIR}"/{conf/httpd.conf,init/*,patches/config.layout} \
		|| die "libdir sed failed"

	epatch "${GENTOO_PATCHDIR}"/patches/*.patch

	# setup the filesystem layout config
	cat "${GENTOO_PATCHDIR}"/patches/config.layout >> "${S}"/config.layout || \
		die "Failed preparing config.layout!"
	sed -i -e "s:version:${PF}:g" "${S}"/config.layout

	# apache2.8 instead of httpd.8 (bug #194828)
	mv docs/man/{httpd,apache2}.8
	sed -i -e 's/httpd\.8/apache2.8/g' Makefile.in

	# patched-in MPMs need the build environment rebuilt
	sed -i -e '/sinclude/d' configure.in
	AT_M4DIR=build eautoreconf

	# ${T} must be not group-writable, else grsec TPE will block it
	chmod g-w "${T}"

	# This package really should upgrade to using pcre's .pc file.
	cat <<-\EOF >"${T}"/pcre-config
	#!/bin/sh
	[ "${flag}" = "--version" ] && set -- --modversion
	exec ${PKG_CONFIG} libpcre "$@"
	EOF
	chmod a+x "${T}"/pcre-config
}

# @FUNCTION: apache-2_src_configure
# @DESCRIPTION:
# This function adds compiler flags and runs econf and emake based on MY_MPM and
# MY_CONF
apache-2_src_configure() {
	tc-export PKG_CONFIG

	# Sanity check in case people have bad mounts/TPE settings. #500928
	if ! "${T}"/pcre-config --help >/dev/null ; then
		eerror "Could not execute ${T}/pcre-config; do you have bad mount"
		eerror "permissions in ${T} or have TPE turned on in your kernel?"
		die "check your runtime settings #500928"
	fi

	# Instead of filtering --as-needed (bug #128505), append --no-as-needed
	# Thanks to Harald van Dijk
	append-ldflags $(no-as-needed)

	# peruser MPM debugging with -X is nearly impossible
	if has peruser ${IUSE_MPMS} && use apache2_mpms_peruser ; then
		use debug && append-flags -DMPM_PERUSER_DEBUG
	fi

	# econf overwrites the stuff from config.layout, so we have to put them into
	# our myconf line too
	ac_cv_path_PKGCONFIG=${PKG_CONFIG} \
	econf \
		--includedir="${EPREFIX}"/usr/include/apache2 \
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/apache2/modules \
		--datadir="${EPREFIX}"/var/www/localhost \
		--sysconfdir="${EPREFIX}"/etc/apache2 \
		--localstatedir="${EPREFIX}"/var \
		--with-mpm=${MY_MPM} \
		--with-apr="${SYSROOT}${EPREFIX}"/usr \
		--with-apr-util="${SYSROOT}${EPREFIX}"/usr \
		--with-pcre="${T}"/pcre-config \
		--with-z="${EPREFIX}"/usr \
		--with-port=80 \
		--with-program-name=apache2 \
		--enable-layout=Gentoo \
		"${MY_CONF[@]}"

	sed -i -e 's:apache2\.conf:httpd.conf:' include/ap_config_auto.h
}

# @FUNCTION: apache-2_src_install
# @DESCRIPTION:
# This function runs `emake install' and generates, installs and adapts the gentoo
# specific configuration files found in the tarball
apache-2_src_install() {
	emake DESTDIR="${D}" MKINSTALLDIRS="mkdir -p" install

	# install our configuration files
	keepdir /etc/apache2/vhosts.d
	keepdir /etc/apache2/modules.d

	generate_load_module
	insinto /etc/apache2
	doins -r "${GENTOO_PATCHDIR}"/conf/*
	use apache2_modules_mime_magic && doins docs/conf/magic

	insinto /etc/logrotate.d
	newins "${GENTOO_PATCHDIR}"/scripts/apache2-logrotate apache2

	# generate a sane default APACHE2_OPTS
	APACHE2_OPTS="-D DEFAULT_VHOST -D INFO"
	use doc && APACHE2_OPTS="${APACHE2_OPTS} -D MANUAL"
	use ssl && APACHE2_OPTS="${APACHE2_OPTS} -D SSL -D SSL_DEFAULT_VHOST"
	use suexec && APACHE2_OPTS="${APACHE2_OPTS} -D SUEXEC"
	if has negotiation ${APACHE2_MODULES} && use apache2_modules_negotiation; then
		APACHE2_OPTS="${APACHE2_OPTS} -D LANGUAGE"
	fi

	sed -i -e "s:APACHE2_OPTS=\".*\":APACHE2_OPTS=\"${APACHE2_OPTS}\":" \
		"${GENTOO_PATCHDIR}"/init/apache2.confd || die "sed failed"

	newconfd "${GENTOO_PATCHDIR}"/init/apache2.confd apache2
	newinitd "${GENTOO_PATCHDIR}"/init/apache2.initd apache2

	# install apache2ctl wrapper for our init script if available
	if test -e "${GENTOO_PATCHDIR}"/scripts/apache2ctl; then
		exeinto /usr/sbin
		doexe "${GENTOO_PATCHDIR}"/scripts/apache2ctl
	else
		dosym /etc/init.d/apache2 /usr/sbin/apache2ctl
	fi

	# provide legacy symlink for apxs, bug 177697
	dosym apxs /usr/sbin/apxs2

	# install some documentation
	dodoc ABOUT_APACHE CHANGES LAYOUT README README.platforms VERSIONING
	dodoc "${GENTOO_PATCHDIR}"/docs/*

	# drop in a convenient link to the manual
	if use doc ; then
		sed -i -e "s:VERSION:${PVR}:" "${ED}/etc/apache2/modules.d/00_apache_manual.conf"
		docompress -x /usr/share/doc/${PF}/manual # 503640
	else
		rm -f "${ED}/etc/apache2/modules.d/00_apache_manual.conf"
		rm -Rf "${ED}/usr/share/doc/${PF}/manual"
	fi

	# the default icons and error pages get stored in
	# /usr/share/apache2/{error,icons}
	dodir /usr/share/apache2
	mv -f "${ED}/var/www/localhost/error" "${ED}/usr/share/apache2/error"
	mv -f "${ED}/var/www/localhost/icons" "${ED}/usr/share/apache2/icons"
	rm -rf "${ED}/var/www/localhost/"
	eend $?

	# set some sane permissions for suexec
	if use suexec ; then
		fowners 0:${SUEXEC_CALLER:-apache} /usr/sbin/suexec
		fperms 4710 /usr/sbin/suexec
		# provide legacy symlink for suexec, bug 177697
		dosym /usr/sbin/suexec /usr/sbin/suexec2
	fi

	# empty dirs
	for i in /var/lib/dav /var/log/apache2 /var/cache/apache2 ; do
		keepdir ${i}
		fowners apache:apache ${i}
		fperms 0750 ${i}
	done
}

# @FUNCTION: apache-2_pkg_postinst
# @DESCRIPTION:
# This function creates test certificates if SSL is enabled and installs the
# default index.html to /var/www/localhost if it does not exist. We do this here
# because the default webroot is a copy of the files that exist elsewhere and we
# don't want them to be managed/removed by portage when apache is upgraded.
apache-2_pkg_postinst() {
	if use ssl && [[ ! -e "${EROOT}/etc/ssl/apache2/server.pem" ]]; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Apache HTTP Server}"
		install_cert /etc/ssl/apache2/server
		ewarn
		ewarn "The location of SSL certificates has changed. If you are"
		ewarn "upgrading from ${CATEGORY}/${PN}-2.2.13 or earlier (or remerged"
		ewarn "*any* apache version), you might want to move your old"
		ewarn "certificates from /etc/apache2/ssl/ to /etc/ssl/apache2/ and"
		ewarn "update your config files."
		ewarn
	fi

	if [[ ! -e "${EROOT}/var/www/localhost" ]] ; then
		mkdir -p "${EROOT}/var/www/localhost/htdocs"
		echo "<html><body><h1>It works!</h1></body></html>" > "${EROOT}/var/www/localhost/htdocs/index.html"
	fi

	echo
	elog "Attention: cgi and cgid modules are now handled via APACHE2_MODULES flags"
	elog "in make.conf. Make sure to enable those in order to compile them."
	elog "In general, you should use 'cgid' with threaded MPMs and 'cgi' otherwise."
	echo

}

EXPORT_FUNCTIONS pkg_setup src_prepare src_configure src_install pkg_postinst
