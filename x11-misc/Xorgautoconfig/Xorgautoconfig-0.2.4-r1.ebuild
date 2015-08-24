# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Xorgautconfig generates xorg.conf files for PPC based computers"
HOMEPAGE="https://dev.gentoo.org/~josejx/Xorgautoconfig.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc ppc64"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/pciutils"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/backingstore.patch
	epatch "${FILESDIR}"/${PN}-lz.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed!"
}

src_install() {
	dodir /usr
	into /usr
	dosbin Xorgautoconfig

	newinitd Xorgautoconfig.init Xorgautoconfig

	dodoc ChangeLog
}
