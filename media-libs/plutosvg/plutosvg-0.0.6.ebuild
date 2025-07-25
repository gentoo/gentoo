# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Tiny SVG rendering library in C"
HOMEPAGE="https://github.com/sammycage/plutosvg"
SRC_URI="https://github.com/sammycage/plutosvg/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv"

IUSE="+freetype"

RDEPEND="
	>=media-libs/plutovg-1.0.0[${MULTILIB_USEDEP}]
	freetype? ( media-libs/freetype:2[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature freetype)
	)
	meson_src_configure
}
