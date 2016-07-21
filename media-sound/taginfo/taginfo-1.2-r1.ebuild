# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="a simple ID3 tag reader for use in shell scripts"
HOMEPAGE="http://freshmeat.net/projects/taginfo"
SRC_URI="http://grecni.com/software/taginfo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/taglib"
DEPEND="${RDEPEND}"

src_compile() {
	emake CC="$(tc-getCXX) ${LDFLAGS} ${CXXFLAGS}" || die
}

src_install() {
	dobin taginfo || die
	dodoc ChangeLog contrib/mp3-resample.sh README
}
