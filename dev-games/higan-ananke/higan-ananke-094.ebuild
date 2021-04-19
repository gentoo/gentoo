# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=higan_v${PV}-source

DESCRIPTION="A higan helper library needed for extra rom load options"
HOMEPAGE="http://byuu.org/higan/"
SRC_URI="http://byuu.org/files/${MY_P}.tar.xz"
S="${WORKDIR}"/${MY_P}/ananke

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	cd "${WORKDIR}"/${MY_P} || die
	default
}

src_compile() {
	emake \
		platform="linux" \
		compiler="$(tc-getCXX)"
}

src_install() {
	newlib.so libananke.so libananke.so.1
	dosym libananke.so.1 /usr/$(get_libdir)/libananke.so
}
