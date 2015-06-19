# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_mount/pam_mount-2.14.ebuild,v 1.5 2015/02/25 15:28:38 ago Exp $

EAPI=4

inherit multilib

DESCRIPTION="A PAM module that can mount volumes for a user session"
HOMEPAGE="http://pam-mount.sourceforge.net"
SRC_URI="mirror://sourceforge/pam-mount/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="crypt ssl selinux"

COMMON_DEPEND=">=sys-libs/pam-0.99
	>=sys-libs/libhx-3.12.1
	>=dev-libs/libxml2-2.6
	crypt? ( >=sys-fs/cryptsetup-1.1.0 )
	ssl? ( >=dev-libs/openssl-0.9.8 )
	selinux? ( sys-libs/libselinux )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	app-arch/xz-utils"
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/util-linux-2.20"

src_configure() {
	econf --with-slibdir="/$(get_libdir)" \
			$(use_with crypt cryptsetup) \
			$(use_with ssl crypto) \
			$(use_with selinux)
}

src_install() {
	default
	use selinux || rm -r "${D}"/etc/selinux
	dodoc doc/*.txt
}
