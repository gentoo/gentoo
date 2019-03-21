# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION="0.32"
VALA_MAX_API_VERSION="0.36" # fix sed line if you increase this

inherit vala cmake-utils

DESCRIPTION="Presenter console with multi-monitor support for PDF files"
HOMEPAGE="https://pdfpc.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gstreamer"

RDEPEND="app-text/poppler[cairo]
	dev-libs/glib:2
	dev-libs/libgee:0.8
	gnome-base/librsvg
	gstreamer? ( media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0 )
	sys-apps/dbus
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)"

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e "s/valac/valac valac-0.36 valac-0.34 valac-0.32/" cmake/vala/FindVala.cmake || die
	vala_src_prepare
}

src_configure(){
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}/etc"
		-DMOVIES=$(usex gstreamer on off)
	)
	cmake-utils_src_configure
}
