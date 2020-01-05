# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"

inherit xdg-utils distutils-r1

DESCRIPTION="A chess client for Gnome"
HOMEPAGE="http://pychess.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gstreamer"

DEPEND="
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP},sqlite]
	gnome-base/librsvg:2
	x11-libs/gtksourceview:3.0
	x11-libs/pango
	x11-themes/adwaita-icon-theme
	gstreamer? (
		dev-python/gst-python:1.0[${PYTHON_USEDEP}]
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)"
RDEPEND="${DEPEND}"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
