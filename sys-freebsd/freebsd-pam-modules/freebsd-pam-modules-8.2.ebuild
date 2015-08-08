# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit bsdmk freebsd multilib pam

DESCRIPTION="FreeBSD's PAM authentication modules"
SLOT="0"
KEYWORDS="~x86-fbsd ~sparc-fbsd"

IUSE="kerberos nis"

SRC_URI="mirror://gentoo/${LIB}.tar.bz2"

RDEPEND=">=sys-auth/openpam-20050201-r1
	kerberos? ( dev-libs/openssl
		virtual/krb5 )"
DEPEND="${RDEPEND}
	=sys-freebsd/freebsd-mk-defs-${RV}*
	=sys-freebsd/freebsd-sources-${RV}*"

S=${WORKDIR}/lib/libpam/modules

pkg_setup() {
	# Avoid installing pam_ssh as that has its own ebuild.
	mymakeopts="${mymakeopts} NO_OPENSSH= "
	use kerberos || mymakeopts="${mymakeopts} NO_KERBEROS= "
	use nis || mymakeopts="${mymakeopts} NO_NIS= "
}

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}"/lib

	for module in pam_deny pam_passwdqc pam_permit; do
		sed -i -e "s:${module}::" "${S}"/modules.inc
	done

	# Avoid using static versions; use gentoo /lib/security dir
	epatch "${FILESDIR}"/${PN}-6.0-gentoo.patch
}

src_install() {
	mkinstall "LIBDIR=/$(get_libdir)/security" || die "install failed"

	dodoc "${FILESDIR}/README.pamd"
}
