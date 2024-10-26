# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A simple ID3 tag reader for use in shell scripts"
HOMEPAGE="http://freshmeat.net/projects/taginfo"
SRC_URI="http://grecni.com/software/taginfo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-libs/taglib"
DEPEND="${RDEPEND}"

src_compile() {
	emake CC="$(tc-getCXX) ${LDFLAGS} ${CXXFLAGS}"
}

src_install() {
	dobin taginfo
	dodoc ChangeLog contrib/mp3-resample.sh README
}
