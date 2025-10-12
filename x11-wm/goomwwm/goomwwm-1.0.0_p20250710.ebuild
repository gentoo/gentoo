# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

GOOMWM_COMMIT="5747442e8842e8b150e75f656dec4b2db225110f"
DESCRIPTION="Get out of my way, Window Manager!"
HOMEPAGE="https://github.com/seanpringle/goomwwm"
SRC_URI="https://github.com/seanpringle/goomwwm/archive/${GOOMWM_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${GOOMWM_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	x11-libs/libXft
	x11-libs/libX11
	x11-libs/libXinerama
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.0_p20250710-makefile.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
	use debug && append-cppflags -DDEBUG
}

src_install() {
	dobin goomwwm
	doman goomwwm.1
}
