# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils autotools

DESCRIPTION="Toolset to help create compilers, cross-compilers, interpreters, and other language processors"
HOMEPAGE="http://cocom.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
RDEPEND="!!media-gfx/hugin"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-configure.patch"
	cd "${S}"/REGEX
	eautoconf
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc CHANGES README
}
