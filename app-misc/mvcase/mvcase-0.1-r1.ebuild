# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mvcase/mvcase-0.1-r1.ebuild,v 1.5 2014/01/14 15:31:35 ago Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A modified version of mv, used to convert filenames to lower/upper case"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/utils/file"
SRC_URI="http://www.ibiblio.org/pub/Linux/utils/file/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-libs/shhopt"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-includes.patch \
		"${FILESDIR}"/${P}-flags.patch
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin mvcase || die
	doman mvcase.1
	dodoc INSTALL
}
