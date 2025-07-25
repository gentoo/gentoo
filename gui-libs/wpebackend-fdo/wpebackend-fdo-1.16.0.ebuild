# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="WPE backend designed for Linux desktop systems"
HOMEPAGE="https://wpewebkit.org/"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="1.0"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	media-libs/libepoxy[egl(+)]
	dev-libs/glib:2
	>=dev-libs/wayland-1.10
	>=gui-libs/libwpe-1.6:1.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dbuild_docs=false # hotdoc not packaged
	)

	meson_src_configure
}
