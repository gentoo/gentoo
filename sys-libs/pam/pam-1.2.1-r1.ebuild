# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit libtool multilib multilib-minimal eutils pam toolchain-funcs flag-o-matic db-use fcaps

MY_PN="Linux-PAM"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Linux-PAM (Pluggable Authentication Modules)"
HOMEPAGE="http://www.linux-pam.org/ https://fedorahosted.org/linux-pam/"
SRC_URI="http://www.linux-pam.org/library/${MY_P}.tar.bz2
	http://www.linux-pam.org/documentation/${MY_PN}-1.2.0-docs.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="audit berkdb cracklib debug nis nls +pie selinux test vim-syntax"

RDEPEND="nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	cracklib? ( >=sys-libs/cracklib-2.9.1-r1[${MULTILIB_USEDEP}] )
	audit? ( >=sys-process/audit-2.2.2[${MULTILIB_USEDEP}] )
	selinux? ( >=sys-libs/libselinux-2.2.2-r4[${MULTILIB_USEDEP}] )
	berkdb? ( >=sys-libs/db-4.8.30-r1[${MULTILIB_USEDEP}] )
	nis? ( >=net-libs/libtirpc-0.2.4-r2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2
	>=sys-devel/flex-2.5.39-r1[${MULTILIB_USEDEP}]
	nls? ( sys-devel/gettext )
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"
PDEPEND="sys-auth/pambase
	vim-syntax? ( app-vim/pam-syntax )"
RDEPEND="${RDEPEND}
	!<sys-apps/openrc-0.11.8
	!sys-auth/openpam
	!sys-auth/pam_userdb
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r7
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

S="${WORKDIR}/${MY_P}"

check_old_modules() {
	local retval="0"

	if sed -e 's:#.*::' "${EROOT}"/etc/pam.d/* 2>/dev/null | fgrep -q pam_stack.so; then
		eerror ""
		eerror "Your current setup is using the pam_stack module."
		eerror "This module is deprecated and no longer supported, and since version"
		eerror "0.99 is no longer installed, nor provided by any other package."
		eerror "The package will be built (to allow binary package builds), but will"
		eerror "not be installed."
		eerror "Please replace pam_stack usage with proper include directive usage,"
		eerror "following the PAM Upgrade guide at the following URL"
		eerror "  http://www.gentoo.org/proj/en/base/pam/upgrade-0.99.xml"
		eerror ""

		retval=1
	fi

	if sed -e 's:#.*::' "${EROOT}"/etc/pam.d/* 2>/dev/null | egrep -q 'pam_(pwdb|console)'; then
		eerror ""
		eerror "Your current setup is using one or more of the following modules,"
		eerror "that are not built or supported anymore:"
		eerror "pam_pwdb, pam_console"
		eerror "If you are in real need for these modules, please contact the maintainers"
		eerror "of PAM through http://bugs.gentoo.org/ providing information about its"
		eerror "use cases."
		eerror "Please also make sure to read the PAM Upgrade guide at the following URL:"
		eerror "  http://www.gentoo.org/proj/en/base/pam/upgrade-0.99.xml"
		eerror ""

		retval=1
	fi

	return ${retval}
}

pkg_pretend() {
	# do not error out, this is just a warning, one could build a binpkg
	# with old modules enabled.
	check_old_modules
}

src_unpack() {
	# Upstream didn't release a new doc tarball (since nothing changed?).
	unpack ${MY_PN}-1.2.0-docs.tar.bz2
	mv Linux-PAM-1.2.{0,1} || die
	unpack ${MY_P}.tar.bz2
}

src_prepare() {
	elibtoolize
}

multilib_src_configure() {
	# Do not let user's BROWSER setting mess us up. #549684
	unset BROWSER

	# Disable automatic detection of libxcrypt; we _don't_ want the
	# user to link libxcrypt in by default, since we won't track the
	# dependency and allow to break PAM this way.
	export ac_cv_header_xcrypt_h=no

	local myconf=(
		--docdir='$(datarootdir)'/doc/${PF}
		--htmldir='$(docdir)/html'
		--libdir='$(prefix)'/$(get_libdir)
		--enable-securedir="${EPREFIX}"/$(get_libdir)/security
		--enable-isadir='.' #464016
		$(use_enable nls)
		$(use_enable selinux)
		$(use_enable cracklib)
		$(use_enable audit)
		$(use_enable debug)
		$(use_enable berkdb db)
		$(use_enable nis)
		$(use_enable pie)
		--with-db-uniquename=-$(db_findver sys-libs/db)
		--disable-prelude
	)

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_compile() {
	emake sepermitlockdir="${EPREFIX}/run/sepermit"
}

multilib_src_install() {
	emake DESTDIR="${D}" install \
		sepermitlockdir="${EPREFIX}/run/sepermit"

	local prefix
	if multilib_is_native_abi; then
		prefix=
		gen_usr_ldscript -a pam pamc pam_misc
	else
		prefix=/usr
	fi

	# create extra symlinks just in case something depends on them...
	local lib
	for lib in pam pamc pam_misc; do
		if ! [[ -f "${ED}"${prefix}/$(get_libdir)/lib${lib}$(get_libname) ]]; then
			dosym lib${lib}$(get_libname 0) ${prefix}/$(get_libdir)/lib${lib}$(get_libname)
		fi
	done
}

DOCS=( CHANGELOG ChangeLog README AUTHORS Copyright NEWS )

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	docinto modules
	local dir
	for dir in modules/pam_*; do
		newdoc "${dir}"/README README."$(basename "${dir}")"
	done

	if use selinux; then
		dodir /usr/lib/tmpfiles.d
		cat - > "${D}"/usr/lib/tmpfiles.d/${CATEGORY}:${PN}:${SLOT}.conf <<EOF
d /run/sepermit 0755 root root
EOF
	fi
}

pkg_preinst() {
	check_old_modules || die "deprecated PAM modules still used"
}

pkg_postinst() {
	ewarn "Some software with pre-loaded PAM libraries might experience"
	ewarn "warnings or failures related to missing symbols and/or versions"
	ewarn "after any update. While unfortunate this is a limit of the"
	ewarn "implementation of PAM and the software, and it requires you to"
	ewarn "restart the software manually after the update."
	ewarn ""
	ewarn "You can get a list of such software running a command like"
	ewarn "  lsof / | egrep -i 'del.*libpam\\.so'"
	ewarn ""
	ewarn "Alternatively, simply reboot your system."
	if [[ -x "${EROOT}"/var/log/tallylog ]] ; then
		elog ""
		elog "Because of a bug present up to version 1.1.1-r2, you have"
		elog "an executable /var/log/tallylog file. You can safely"
		elog "correct it by running the command"
		elog "  chmod -x /var/log/tallylog"
		elog ""
	fi

	# The pam_unix module needs to check the password of the user which requires
	# read access to /etc/shadow only.
	fcaps cap_dac_override sbin/unix_chkpwd
}
