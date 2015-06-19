# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/catdvi/catdvi-0.14-r1.ebuild,v 1.5 2011/12/04 14:39:58 hwoarang Exp $

EAPI=4

inherit eutils autotools toolchain-funcs

DESCRIPTION="DVI to plain text translator"
HOMEPAGE="http://catdvi.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/tex-base"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-kpathsea.patch"
	eautoconf
}

src_compile() {
	# Do not use plain emake here, because make tests
	# may cache fonts and generate sandbox violations.
	emake catdvi CC="$(tc-getCC)"
}

src_install() {
	dobin catdvi
	doman catdvi.1
	dodoc AUTHORS ChangeLog NEWS README TODO
}
