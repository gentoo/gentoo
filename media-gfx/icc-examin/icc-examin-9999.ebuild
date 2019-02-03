# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic git-r3 xdg-utils

DESCRIPTION="Viewer for ICC and CGATS, argyll gamut vrml visualisations and GPU gamma tables"
HOMEPAGE="https://www.oyranos.org/icc-examin/"
EGIT_REPO_URI="https://github.com/oyranos-cms/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	app-admin/elektra
	media-libs/freetype
	media-libs/ftgl
	media-libs/libXcm[X]
	media-libs/oyranos
	media-libs/tiff:0
	virtual/jpeg:0
	virtual/opengl
	x11-libs/fltk[opengl]
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXxf86vm
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/libintl
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${PN}-0.56-fltk.patch" )

src_configure() {
	append-cxxflags -fpermissive
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
