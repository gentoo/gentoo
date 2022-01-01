# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Platform-agnostic interfaces for WPE WebKit"
HOMEPAGE="https://wpewebkit.org/"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="1.0"

KEYWORDS="amd64 arm arm64 ~ia64 ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	media-libs/mesa[egl]
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dbuild-docs=false # hotdoc not packaged
	)
	meson_src_configure
}
