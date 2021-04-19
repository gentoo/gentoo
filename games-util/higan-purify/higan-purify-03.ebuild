# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=purify_v${PV}-source
DESCRIPTION="Rom purifier for higan"
HOMEPAGE="http://byuu.org/higan/"
SRC_URI="https://higan.googlecode.com/files/${MY_P}.tar.xz"
S="${WORKDIR}"/${MY_P}/purify

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-games/higan-ananke
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-QA.patch
)

src_prepare() {
	default

	sed -i \
		-e "/handle/s#/usr/local/lib#/usr/$(get_libdir)#" \
		nall/dl.hpp || die
}

src_compile() {
	emake \
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		platform="x" \
		compiler="$(tc-getCXX)" \
		phoenix="gtk"
}

src_install() {
	dobin purify
}
