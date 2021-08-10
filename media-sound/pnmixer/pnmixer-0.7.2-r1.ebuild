# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-v${PV}"
inherit cmake xdg-utils

DESCRIPTION="Volume mixer for the system tray"
HOMEPAGE="https://github.com/nicklan/pnmixer"
SRC_URI="https://github.com/nicklan/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc libnotify nls"

RDEPEND="
	dev-libs/glib:2
	media-libs/alsa-lib
	x11-libs/gtk+:3
	x11-libs/libX11
	libnotify? ( x11-libs/libnotify )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${MY_P}"

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

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
