# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="WPE backend designed for Linux desktop systems"
HOMEPAGE="https://wpewebkit.org/"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="1.0"
IUSE=""

KEYWORDS="~amd64"

RDEPEND="
	media-libs/mesa[egl]
	dev-libs/glib:2
	>=dev-libs/wayland-1.10
	gui-libs/libwpe:1.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-eglmesaext-include.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF # hotdoc not packaged
	)

	cmake-utils_src_configure
}
