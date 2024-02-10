# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Provides functionality for gaming input devices"

HOMEPAGE="https://sourceforge.net/projects/libgaminggear/"
SRC_URI="mirror://sourceforge/libgaminggear/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-db/sqlite-3.17:3
	dev-libs/glib:2
	media-libs/libcanberra
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/pango
"
DEPEND="${RDEPEND}
	dev-libs/libgudev
	media-libs/harfbuzz
"
BDEPEND="
	dev-util/glib-utils
	doc? ( app-text/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-doc.patch
	"${FILESDIR}"/${P}-cmake-3.13.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_DOC="$(usex doc)"
	)
	cmake_src_configure
}
