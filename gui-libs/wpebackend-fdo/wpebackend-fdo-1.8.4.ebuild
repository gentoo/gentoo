# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="WPE backend designed for Linux desktop systems"
HOMEPAGE="https://wpewebkit.org/"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="1.0"

KEYWORDS="amd64 arm arm64 ~ia64 ~ppc64 ~sparc x86"

RDEPEND="
	media-libs/libepoxy[egl]
	dev-libs/glib:2
	>=dev-libs/wayland-1.10
	>=gui-libs/libwpe-1.5.90:1.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF # hotdoc not packaged
	)

	cmake_src_configure
}
