# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="sqlite"

inherit gnome2-utils distutils-r1 xdg-utils

DESCRIPTION="A chess client for Gnome"
HOMEPAGE="http://pychess.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gstreamer"

DEPEND="
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-base/librsvg:2
	x11-libs/gtksourceview:3.0
	x11-libs/pango
	x11-themes/adwaita-icon-theme
	gstreamer? (
		dev-python/gst-python:1.0
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
"
RDEPEND=${DEPEND}

python_install() {
	distutils-r1_python_install

	# bug 487706
	sed -i \
		-e "s/@PYTHON@/${EPYTHON}/" \
		"${ED%/}/$(python_get_sitedir)"/${PN}/Players/engineNest.py || die
}

python_install_all() {
	DOCS="AUTHORS README.md" \
		distutils-r1_python_install_all
}

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
}
