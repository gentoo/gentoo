# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-pam-modules/freebsd-pam-modules-9.1-r1.ebuild,v 1.1 2013/06/27 20:54:01 aballier Exp $

inherit bsdmk freebsd multilib pam

DESCRIPTION="FreeBSD's PAM authentication modules"
SLOT="0"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

IUSE="kerberos nis"

SRC_URI="mirror://gentoo/${LIB}.tar.bz2"

RDEPEND=">=sys-auth/openpam-20050201-r1
	kerberos? ( dev-libs/openssl
		virtual/krb5 )"
DEPEND="${RDEPEND}
	=sys-freebsd/freebsd-mk-defs-${RV}*
	=sys-freebsd/freebsd-sources-${RV}*"

S=${WORKDIR}/lib/libpam/modules

PATCHES=( "${FILESDIR}"/${PN}-9.0-gentoo.patch )

pkg_setup() {
	# Avoid installing pam_ssh as that has its own ebuild.
	mymakeopts="${mymakeopts} NO_OPENSSH= "
	use kerberos || mymakeopts="${mymakeopts} NO_KERBEROS= "
	use nis || mymakeopts="${mymakeopts} NO_NIS= "
}

src_unpack() {
	freebsd_src_unpack

	for module in pam_deny pam_passwdqc pam_permit pam_krb5; do
		sed -i -e "s:${module}::" "${S}"/modules.inc
	done
}

src_install() {
	mkinstall "LIBDIR=/$(get_libdir)/security" || die "install failed"

	dodoc "${FILESDIR}/README.pamd"
}
