# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"
inherit cmake xdg

DESCRIPTION="Volume mixer for the system tray"
HOMEPAGE="https://github.com/nicklan/pnmixer"
SRC_URI="https://github.com/nicklan/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc libnotify nls"

RDEPEND="
	dev-libs/glib:2
	media-libs/alsa-lib
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	libnotify? ( x11-libs/libnotify )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${P}-fix-assert-if-volume-gt-100.patch"
	"${FILESDIR}/${P}-fix-possible-garbage-value.patch"
	"${FILESDIR}/${P}-fix-possible-memleak.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION="$(usex doc)"
		-DWITH_LIBNOTIFY="$(usex libnotify)"
		-DENABLE_NLS="$(usex nls)"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)
	cmake_src_configure
}
