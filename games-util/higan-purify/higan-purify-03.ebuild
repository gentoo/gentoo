# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs

MY_P=purify_v${PV}-source

DESCRIPTION="Rom purifier for higan"
HOMEPAGE="http://byuu.org/higan/"
SRC_URI="https://higan.googlecode.com/files/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-games/higan-ananke
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}/purify

src_prepare() {
	epatch "${FILESDIR}"/${P}-QA.patch
	sed -i \
		-e "/handle/s#/usr/local/lib#/usr/$(get_libdir)#" \
		nall/dl.hpp || die
}

src_compile() {
	emake \
		platform="x" \
		compiler="$(tc-getCXX)" \
		phoenix="gtk"
}

src_install() {
	dobin purify
}
