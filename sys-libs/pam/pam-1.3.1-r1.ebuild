# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools db-use fcaps multilib-minimal toolchain-funcs usr-ldscript

DESCRIPTION="Linux-PAM (Pluggable Authentication Modules)"
HOMEPAGE="https://github.com/linux-pam/linux-pam"
SRC_URI="https://github.com/linux-pam/linux-pam/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="audit berkdb +cracklib debug nis nls +pie selinux static-libs"

BDEPEND="app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xml-dtd:4.3
	app-text/docbook-xml-dtd:4.4
	app-text/docbook-xml-dtd:4.5
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	nls? ( sys-devel/gettext )"

DEPEND="
	audit? ( >=sys-process/audit-2.2.2[${MULTILIB_USEDEP}] )
	berkdb? ( >=sys-libs/db-4.8.30-r1:=[${MULTILIB_USEDEP}] )
	cracklib? ( >=sys-libs/cracklib-2.9.1-r1[${MULTILIB_USEDEP}] )
	selinux? ( >=sys-libs/libselinux-2.2.2-r4[${MULTILIB_USEDEP}] )
	nis? ( >=net-libs/libtirpc-0.2.4-r2[${MULTILIB_USEDEP}] )
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )"

RDEPEND="${DEPEND}"

PDEPEND="sys-auth/pambase"

S="${WORKDIR}/linux-${P}"

src_prepare() {
	default
	eapply "${FILESDIR}/${PN}-remove-browsers.patch"
	touch ChangeLog || die
	eautoreconf
}

multilib_src_configure() {
	# Do not let user's BROWSER setting mess us up. #549684
	unset BROWSER

	# Disable automatic detection of libxcrypt; we _don't_ want the
	# user to link libxcrypt in by default, since we won't track the
	# dependency and allow to break PAM this way.

	export ac_cv_header_xcrypt_h=no

	local myconf=(
		--with-db-uniquename=-$(db_findver sys-libs/db)
		--enable-securedir="${EPREFIX}"/$(get_libdir)/security
		--libdir=/usr/$(get_libdir)
		--disable-prelude
		$(use_enable audit)
		$(use_enable berkdb db)
		$(use_enable cracklib)
		$(use_enable debug)
		$(use_enable nis)
		$(use_enable nls)
		$(use_enable pie)
		$(use_enable selinux)
		$(use_enable static-libs static)
		--enable-isadir='.' #464016
		)
	ECONF_SOURCE="${S}" econf ${myconf[@]}
}

multilib_src_compile() {
	emake sepermitlockdir="${EPREFIX}/run/sepermit"
}

multilib_src_install() {
	emake DESTDIR="${D}" install \
		sepermitlockdir="${EPREFIX}/run/sepermit"

	gen_usr_ldscript -a pam pam_misc pamc
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die

	if use selinux; then
		dodir /usr/lib/tmpfiles.d
		cat - > "${D}"/usr/lib/tmpfiles.d/${CATEGORY}:${PN}:${SLOT}.conf <<EOF
d /run/sepermit 0755 root root
EOF
	fi
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

	# The pam_unix module needs to check the password of the user which requires
	# read access to /etc/shadow only.
	fcaps cap_dac_override sbin/unix_chkpwd
}
