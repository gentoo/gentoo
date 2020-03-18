# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vdr-plugin-2.eclass
# @MAINTAINER:
# Gentoo VDR Project <vdr@gentoo.org>
# @AUTHOR:
# Matthias Schwarzott <zzam@gentoo.org>
# Joerg Bornkessel <hd_brummy@gentoo.org>
# Christian Ruppert <idl0r@gentoo.org>
# (undisclosed contributors)
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: common vdr plugin ebuild functions
# @DESCRIPTION:
# Eclass for easing maintenance of vdr plugin ebuilds

# @ECLASS-VARIABLE: VDR_CONFD_FILE
# @DEFAULT_UNSET
# @DESCRIPTION:
# A plugin config file can be specified through the $VDR_CONFD_FILE variable, it
# defaults to ${FILESDIR}/confd. Each config file will be installed as e.g.
# ${D}/etc/conf.d/vdr.${VDRPLUGIN}

# @ECLASS-VARIABLE: VDR_RCADDON_FILE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Installing rc-addon files is basically the same as for plugin config files
# (see above), it's just using the $VDR_RCADDON_FILE variable instead.
# The default value when $VDR_RCADDON_FILE is undefined is:
# ${FILESDIR}/rc-addon.sh and will be installed as
# ${VDR_RC_DIR}/plugin-${VDRPLUGIN}.sh
#
# The rc-addon files will be sourced by the startscript when the specific plugin
# has been enabled.
# rc-addon files may be used to prepare everything that is necessary for the
# plugin start/stop, like passing extra command line options and so on.
#
# NOTE: rc-addon files must be valid shell scripts!

# @ECLASS-VARIABLE: GENTOO_VDR_CONDITIONAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# This is a hack for ebuilds like vdr-xineliboutput that want to
# conditionally install a vdr-plugin

# @ECLASS-VARIABLE: PO_SUBDIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# By default, translation are found in"${S}"/po but this
# default can be overridden by defining PO_SUBDIR.
#
# Example:
# @CODE
# PO_SUBDIR="bla foo/bla"
# @CODE

# @FUNCTION: fix_vdr_libsi_include
# @DESCRIPTION:
# Plugins failed on compile with wrong path of libsi includes,
# this can be fixed by 'function + space separated list of files'
#
# Example:
# @CODE
# fix_vdr_libsi_include bla.c foo.c
# @CODE

# @FUNCTION: vdr_remove_i18n_include
# @DESCRIPTION:
# Compile will fail if plugin still use the old i18n language handling,
# most parts are fixed by vdr-plugin-2.eclass internal functions itself.
# Remove unneeded i18.n includes from files, if they are still wrong there,
# this can be fixed by 'function + space separated list of files"
#
# Example:
# @CODE
# vdr_remove_i18n_include bla.n foo.n
# @CODE

# Applying your own local/user patches:
# This is done by using the
# (EAPI = 5) epatch_user() function of the eutils.eclass,
# (EAPI = 6,7) eapply_user function integrated in EAPI = 6.
# Simply add your patches into one of these directories:
# /etc/portage/patches/<CATEGORY>/<PF|P|PN>/
# Quote: where the first of these three directories to exist will be the one to
# use, ignoring any more general directories which might exist as well.
#
# For more details about it please take a look at the eutils.class.

[[ ${EAPI} == [5] ]] && inherit multilib
[[ ${EAPI} == [56] ]] && inherit eutils
inherit flag-o-matic toolchain-funcs unpacker

case ${EAPI:-0} in
	5|6|7)
	;;
	*) die "EAPI ${EAPI} unsupported."
	;;
esac

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_compile src_install pkg_postinst pkg_postrm pkg_config

IUSE=""

# Name of the plugin stripped from all vdrplugin-, vdr- and -cvs pre- and postfixes
VDRPLUGIN="${PN/#vdrplugin-/}"
VDRPLUGIN="${VDRPLUGIN/#vdr-/}"
VDRPLUGIN="${VDRPLUGIN/%-cvs/}"

DESCRIPTION="vdr Plugin: ${VDRPLUGIN} (based on vdr-plugin-2.eclass)"

# Works in most cases
S="${WORKDIR}/${VDRPLUGIN}-${PV}"

# depend on headers for DVB-driver
COMMON_DEPEND=">=media-tv/gentoo-vdr-scripts-0.4.2"

DEPEND="${COMMON_DEPEND}
	virtual/linuxtv-dvb-headers"
RDEPEND="${COMMON_DEPEND}
	>=app-eselect/eselect-vdr-0.0.2"

if [[ "${GENTOO_VDR_CONDITIONAL:-no}" = "yes" ]]; then
	IUSE="${IUSE} vdr"
	DEPEND="vdr? ( ${DEPEND} )"
	RDEPEND="vdr? ( ${RDEPEND} )"
fi

# New method of storing plugindb
#   Called from src_install
#   file maintained by normal portage-methods
vdr_create_plugindb_file() {
	local NEW_VDRPLUGINDB_DIR=/usr/share/vdr/vdrplugin-rebuild/
	local DB_FILE="${NEW_VDRPLUGINDB_DIR}/${CATEGORY}-${PF}"
	insinto "${NEW_VDRPLUGINDB_DIR}"

#	BUG: portage-2.1.4_rc9 will delete the EBUILD= line, so we cannot use this code.
#	cat <<-EOT > "${D}/${DB_FILE}"
#		VDRPLUGIN_DB=1
#		CREATOR=ECLASS
#		EBUILD=${CATEGORY}/${PN}
#		EBUILD_V=${PVR}
#	EOT
#	obsolet? fix me later...
	{
		echo "VDRPLUGIN_DB=1"
		echo "CREATOR=ECLASS"
		echo "EBUILD=${CATEGORY}/${PN}"
		echo "EBUILD_V=${PVR}"
		echo "PLUGINS=\"$@\""
	} > "${D%/}/${DB_FILE}"
}

vdr_create_header_checksum_file() {
	# Danger: Not using $ROOT here, as compile will also not use it !!!
	# If vdr in $ROOT and / differ, plugins will not run anyway

	local CHKSUM="header-md5-vdr"

	if [[ -f ${VDR_CHECKSUM_DIR}/header-md5-vdr ]]; then
		cp "${VDR_CHECKSUM_DIR}/header-md5-vdr" "${CHKSUM}"
	elif type -p md5sum >/dev/null 2>&1; then
		(
			cd "${VDR_INCLUDE_DIR}"
			md5sum *.h libsi/*.h|LC_ALL=C sort --key=2
		) > "${CHKSUM}"
	else
		die "Could not create md5 checksum of headers"
	fi

	insinto "${VDR_CHECKSUM_DIR}"
	local p_name
	for p_name; do
		newins "${CHKSUM}" "header-md5-${p_name}"
	done
}

fix_vdr_libsi_include() {
	eqawarn "Fixing include of libsi-headers"
	local f
	for f; do
		sed -i "${f}" \
			-e '/#include/s:"\(.*libsi.*\)":<\1>:' \
			-e '/#include/s:<.*\(libsi/.*\)>:<vdr/\1>:'
	done
}

vdr_patchmakefile() {
	einfo "Patching Makefile"
	[[ -e Makefile ]] || die "Makefile of plugin can not be found!"
	cp Makefile "${WORKDIR}"/Makefile.before

	# plugin makefiles use VDRDIR in strange ways
	# assumptions:
	#   1. $(VDRDIR) contains Make.config
	#   2. $(VDRDIR) contains config.h
	#   3. $(VDRDIR)/include/vdr contains the headers
	#   4. $(VDRDIR) contains main vdr Makefile
	#   5. $(VDRDIR)/locale exists
	#   6. $(VDRDIR) allows to access vdr source files
	#
	# We only have one directory (for now /usr/include/vdr),
	# that contains vdr-headers and Make.config.
	# To satisfy 1-3 we do this:
	#   Set VDRDIR=/usr/include/vdr
	#   Set VDRINCDIR=/usr/include
	#   Change $(VDRDIR)/include to $(VDRINCDIR)

	sed -i Makefile \
		-e "s:^VDRDIR.*$:VDRDIR = ${VDR_INCLUDE_DIR}:" \
		-e "/^VDRDIR/a VDRINCDIR = ${VDR_INCLUDE_DIR%/vdr}" \
		-e '/VDRINCDIR.*=/!s:$(VDRDIR)/include:$(VDRINCDIR):' \
		\
		-e 's:-I$(DVBDIR)/include::' \
		-e 's:-I$(DVBDIR)::'

	if ! grep -q APIVERSION Makefile; then
		ebegin "  Converting to APIVERSION"
		sed -i Makefile \
			-e 's:^APIVERSION = :APIVERSION ?= :' \
			-e 's:$(LIBDIR)/$@.$(VDRVERSION):$(LIBDIR)/$@.$(APIVERSION):' \
			-e '/VDRVERSION =/a\APIVERSION = $(shell sed -ne '"'"'/define APIVERSION/s/^.*"\\(.*\\)".*$$/\\1/p'"'"' $(VDRDIR)/config.h)'
		eend $?
	fi

	# Correcting Compile-Flags
	# Do not overwrite CXXFLAGS, add LDFLAGS if missing
	sed -i Makefile \
		-e '/^CXXFLAGS[[:space:]]*=/s/=/?=/' \
		-e '/LDFLAGS/!s:-shared:$(LDFLAGS) -shared:'

	# Disabling file stripping, the package manager takes care of it
	sed -i Makefile \
		-e '/@.*strip/d' \
		-e '/strip \$(LIBDIR)\/\$@/d' \
		-e 's/STRIP.*=.*$/STRIP = true/'

	# Use a file instead of a variable as single-stepping via ebuild
	# destroys environment.
	touch "${WORKDIR}"/.vdr-plugin_makefile_patched
}

vdr_gettext_missing() {
	# plugins without converting to gettext

	local GETTEXT_MISSING=$( grep xgettext Makefile )
	if [[ -z ${GETTEXT_MISSING} ]]; then
		eqawarn "Plugin isn't converted to gettext handling!"
	fi
}

vdr_detect_po_dir() {
#	helper function to find the
#	DIR ${S}/po or DIR ${S]/_subdir_/po

	[[ -f po ]] && local po_dir="${S}"
	local po_subdir=( ${S}/${PO_SUBDIR} )
	local f

	pofile_dir=( ${po_dir} ${po_subdir[*]} )
}

vdr_linguas_support() {
#	Patching Makefile for linguas support.
#	Only locales, enabled through the LINGUAS (make.conf) variable will be
#	compiled and installed.

	einfo "Patching for Linguas support"
	einfo "available Languages for ${P} are:"

	vdr_detect_po_dir

	for f in ${pofile_dir[*]}; do
		if [[ -d ${f}/po ]]; then
			PLUGIN_LINGUAS=$( ls ${f}/po --ignore="*.pot" | sed -e "s:.po::g" | cut -d_ -f1 | tr \\\012 ' ' )
		fi
		einfo "LINGUAS=\"${PLUGIN_LINGUAS}\""

		sed -i ${f}/Makefile \
			-e 's:\$(wildcard[[:space:]]*\$(PODIR)/\*.po):\$(foreach dir,\$(LINGUAS),\$(wildcard \$(PODIR)\/\$(dir)\*.po)):' \
			|| die "sed failed for Linguas"
	done

	strip-linguas ${PLUGIN_LINGUAS} en
}

vdr_i18n() {
#	i18n handling was deprecated since >=media-video/vdr-1.5.9,
#	finally with >=media-video/vdr-1.7.27 it has been dropped entirely and some
#	plugins will fail to compile because they're still using the old variant.
#	Simply remove the i18n.o object from Makefile (OBJECT) and
#	remove "static const tI18nPhrase*" from i18n.h.

	vdr_gettext_missing

	local I18N_OBJECT=$( grep i18n.o Makefile )
	if [[ -n ${I18N_OBJECT} ]]; then

		if [[ "${KEEP_I18NOBJECT:-no}" = "yes" ]]; then
			eqawarn "Forced to keep i18n.o"
		else
			sed -i "s:i18n.o::g" Makefile
			eqawarn "OBJECT i18n.o found, removed per sed"
		fi
	fi

	local I18N_STRING=$( [[ -e i18n.h ]] && grep tI18nPhrase i18n.h )
	if [[ -n ${I18N_STRING} ]]; then
		sed -i "s:^extern[[:space:]]*const[[:space:]]*tI18nPhrase://static const tI18nPhrase:" i18n.h
		eqawarn "obsolete tI18nPhrase found, disabled per sed, please recheck"
	fi
}

vdr_remove_i18n_include() {
	# remove uneeded i18.n includes

	local f
	for f; do
		sed -i "${f}" \
		-e "s:^#include[[:space:]]*\"i18n.h\"://:"
	done

	eqawarn "removed i18n.h include in ${@}"
}

vdr-plugin-2_print_enable_command() {
	local p_name c=0 l=""
	for p_name in ${vdr_plugin_list}; do
		c=$(( c+1 ))
		l="$l ${p_name#vdr-}"
	done

	elog
	case $c in
	1)	elog "Installed plugin${l}" ;;
	*)	elog "Installed $c plugins:${l}" ;;
	esac
	elog "To activate a plugin execute this command:"
	elog "\teselect vdr-plugin enable <plugin_name> ..."
	elog
}

has_vdr() {
	[[ -f "${VDR_INCLUDE_DIR}"/config.h ]]
}

## exported functions

vdr-plugin-2_pkg_setup() {
	# missing ${chost}- tag
	tc-export CC CXX

	# -fPIC is needed for shared objects on some platforms (amd64 and others)
	append-flags -fPIC

	# Plugins need to be compiled with position independent code, otherwise linking
	# VDR against it will fail
	append-cxxflags -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE

	# Where should the plugins live in the filesystem
	VDR_PLUGIN_DIR=$(pkg-config --variable=libdir vdr)

	VDR_CHECKSUM_DIR="${VDR_PLUGIN_DIR%/plugins}/checksums"

	VDR_RC_DIR="/usr/share/vdr/rcscript"

	# Pathes to includes
	VDR_INCLUDE_DIR="/usr/include/vdr"
	DVB_INCLUDE_DIR="/usr/include"

	TMP_LOCALE_DIR="${WORKDIR}/tmp-locale"

	LOCDIR=$(pkg-config --variable=locdir vdr)

	if ! has_vdr; then
		# set to invalid values to detect abuses
		VDRVERSION="eclass_no_vdr_installed"
		APIVERSION="eclass_no_vdr_installed"

		if [[ "${GENTOO_VDR_CONDITIONAL:-no}" = "yes" ]] && ! use vdr; then
			einfo "VDR not found!"
		else
			# if vdr is required
			die "VDR not found!"
		fi
		return
	fi

	VDRVERSION=$(awk -F'"' '/define VDRVERSION/ {print $2}' "${VDR_INCLUDE_DIR}"/config.h)
	APIVERSION=$(pkg-config --variable=apiversion vdr)

	einfo "Compiling against"
	einfo "\tvdr-${VDRVERSION} [API version ${APIVERSION}]"

	if [[ -n "${VDR_LOCAL_PATCHES_DIR}" ]]; then
		eerror "Using VDR_LOCAL_PATCHES_DIR is deprecated!"
		eerror "Please move all your patches into"
		eerror "${EROOT%/}/etc/portage/patches/${CATEGORY}/${P}"
		eerror "and remove or unset the VDR_LOCAL_PATCHES_DIR variable."
		die
	fi
}

vdr-plugin-2_src_util() {
	while [ "$1" ]; do
		case "$1" in
		all)
			vdr-plugin-2_src_util unpack add_local_patch patchmakefile linguas_patch i18n
			;;
		prepare)
			vdr-plugin-2_src_util add_local_patch patchmakefile linguas_patch i18n
			;;
		unpack)
			unpacker_src_unpack
			;;
		add_local_patch)
			cd "${S}" || die "Could not change to plugin-source-directory (src_util)"
			if [[ ${EAPI} != [5] ]]; then
				eapply_user
			else
				epatch_user
			fi
			;;
		patchmakefile)
			cd "${S}" || die "Could not change to plugin-source-directory (src_util)"
			vdr_patchmakefile
			;;
		i18n)
			vdr_i18n
			;;
		linguas_patch)
			vdr_linguas_support
			;;
		esac

		shift
	done
}

vdr-plugin-2_src_unpack() {
	if [[ -z ${VDR_INCLUDE_DIR} ]]; then
		eerror "Wrong use of vdr-plugin-2.eclass."
		eerror "An ebuild for a vdr-plugin will not work without calling vdr-plugin-2_src_unpack."
		echo
		eerror "Please report this at bugs.gentoo.org."
		die "vdr-plugin-2_src_unpack not called!"
	fi

	if [ -z "$1" ]; then
		vdr-plugin-2_src_util unpack
	else
		vdr-plugin-2_src_util $@
	fi
}

vdr-plugin-2_src_prepare() {
	if [[ -z ${VDR_INCLUDE_DIR} ]]; then
		eerror "Wrong use of vdr-plugin-2.eclass."
		eerror "An ebuild for a vdr-plugin will not work without calling vdr-plugin-2_src_prepare."
		echo
		eerror "Please report this at bugs.gentoo.org."
		die "vdr-plugin-2_src_prepare not called!"
	fi

	[[ ${EAPI} == [5] ]] && [[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	[[ ${EAPI} != [5] ]] && [[ ${PATCHES[@]} ]] && eapply "${PATCHES[@]}"

	debug-print "$FUNCNAME: applying user patches"

	vdr-plugin-2_src_util prepare
}

vdr-plugin-2_src_compile() {
	[ -z "$1" ] && vdr-plugin-2_src_compile compile

	while [ "$1" ]; do
		case "$1" in
		compile)
			if [[ ! -f ${WORKDIR}/.vdr-plugin_makefile_patched ]]; then
				eerror "Wrong use of vdr-plugin-2.eclass."
				eerror "An ebuild for a vdr-plugin will not work without"
				eerror "calling vdr-plugin-2_src_compile to patch the Makefile."
				echo
				eerror "Please report this at bugs.gentoo.org."
				die "vdr-plugin-2_src_compile not called!"
			fi
			cd "${S}" || die "could not change to plugin source directory (src_compile)"

			emake all ${BUILD_PARAMS} \
				LOCALEDIR="${TMP_LOCALE_DIR}" \
				LOCDIR="${TMP_LOCALE_DIR}" \
				LIBDIR="${S}" \
				TMPDIR="${T}" \
				|| die "emake all failed"
			;;
		esac

		shift
	done
}

vdr-plugin-2_src_install() {
	if [[ -z ${VDR_INCLUDE_DIR} ]]; then
		eerror "Wrong use of vdr-plugin-2.eclass."
		eerror "An ebuild for a vdr-plugin will not work without calling vdr-plugin-2_src_install."
		echo
		eerror "Please report this at bugs.gentoo.org."
		die "vdr-plugin-2_src_install not called!"
	fi

	cd "${WORKDIR}" || die "could not change to plugin workdir directory (src_install)"

	if [[ -n ${VDR_MAINTAINER_MODE} ]]; then
		local mname="${P}-Makefile"
		cp "${S}"/Makefile "${mname}.patched"
		cp Makefile.before "${mname}.before"

		diff -u "${mname}.before" "${mname}.patched" > "${mname}.diff"

		insinto "/usr/share/vdr/maintainer-data/makefile-changes"
		doins "${mname}.diff"

		insinto "/usr/share/vdr/maintainer-data/makefile-before"
		doins "${mname}.before"

		insinto "/usr/share/vdr/maintainer-data/makefile-patched"
		doins "${mname}.patched"

	fi

	cd "${S}" || die "could not change to plugin source directory (src_install)"

	local SOFILE_STRING=$(grep SOFILE Makefile)
	if [[ -n ${SOFILE_STRING} ]]; then
		emake install \
		${BUILD_PARAMS} \
		TMPDIR="${T}" \
		DESTDIR="${D%/}" \
		|| die "emake install (makefile target) failed"
	else
		eqawarn "Plugin use still the old Makefile handling"
		insinto "${VDR_PLUGIN_DIR}"
		doins libvdr-*.so.*
	fi

	if [[ -d ${TMP_LOCALE_DIR} ]]; then
		einfo "Installing locales"
		cd "${TMP_LOCALE_DIR}" || die "could not change to TMP_LOCALE_DIR"

		local linguas
		for linguas in ${LINGUAS[*]}; do
		insinto "${LOCDIR}"
		cp -r --parents ${linguas}* ${D%/}/${LOCDIR}
		done
	fi

	cd "${D%/}/usr/$(get_libdir)/vdr/plugins" || die "could not change to D/usr/libdir/vdr/plugins"

	# create list of all created plugin libs
	vdr_plugin_list=""
	local p_name
	for p in libvdr-*.so.*; do
		p_name="${p%.so*}"
		p_name="${p_name#lib}"
		vdr_plugin_list="${vdr_plugin_list} ${p_name}"
	done

	cd "${S}" || die "could not change to plugin source directory (src_install)"

	vdr_create_header_checksum_file ${vdr_plugin_list}
	vdr_create_plugindb_file ${vdr_plugin_list}

	if [[ ${EAPI} != [45] ]]; then
		einstalldocs
	else
		local docfile
			for docfile in README* HISTORY CHANGELOG; do
				[[ -f ${docfile} ]] && dodoc ${docfile}
			done
	fi

	# if VDR_CONFD_FILE is empty and ${FILESDIR}/confd exists take it
	[[ -z ${VDR_CONFD_FILE} ]] && [[ -e ${FILESDIR}/confd ]] && VDR_CONFD_FILE=${FILESDIR}/confd

	if [[ -n ${VDR_CONFD_FILE} ]]; then
		newconfd "${VDR_CONFD_FILE}" vdr.${VDRPLUGIN}
	fi

	# if VDR_RCADDON_FILE is empty and ${FILESDIR}/rc-addon.sh exists take it
	[[ -z ${VDR_RCADDON_FILE} ]] && [[ -e ${FILESDIR}/rc-addon.sh ]] && VDR_RCADDON_FILE=${FILESDIR}/rc-addon.sh

	if [[ -n ${VDR_RCADDON_FILE} ]]; then
		insinto "${VDR_RC_DIR}"
		newins "${VDR_RCADDON_FILE}" plugin-${VDRPLUGIN}.sh
	fi
}

vdr-plugin-2_pkg_postinst() {
	vdr-plugin-2_print_enable_command

	if [[ -n "${VDR_CONFD_FILE}" ]]; then
		elog "Please have a look at the config-file"
		elog "\t/etc/conf.d/vdr.${VDRPLUGIN}"
		elog
	fi
}

vdr-plugin-2_pkg_postrm() {
:
}

vdr-plugin-2_pkg_config() {
:
}
