# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Get out of my way, Window Manager!"
HOMEPAGE="https://github.com/seanpringle/goomwwm"
SRC_URI="https://github.com/seanpringle/goomwwm/archive/${PV}.tar.gz -> ${P}-github.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	x11-libs/libXft
	x11-libs/libX11
	x11-libs/libXinerama"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC PKG_CONFIG
	use debug && append-cppflags -DDEBUG
}

src_install() {
	dobin goomwwm
	doman goomwwm.1
}
