# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10,11,12,13} )
inherit python-r1 desktop wrapper xdg-utils

DESCRIPTION="GUI for lossless cropping of jpeg images"
HOMEPAGE="https://emergent.unpythonic.net/01248401946"
SRC_URI="https://github.com/jepler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	media-libs/exiftool
	media-gfx/imagemagick"

install_cropgui_wrapper() {
	python_domodule cropgtk.py cropgui_common.py filechooser.py cropgui.glade
	make_wrapper "${PN}.tmp" "${PYTHON} $(python_get_sitedir)/${PN}/cropgtk.py"
	python_newexe "${ED}/usr/bin/${PN}.tmp" "${PN}"
	rm "${ED}/usr/bin/${PN}.tmp" || die
}

src_install() {
	python_moduleinto "${PN}"
	python_foreach_impl install_cropgui_wrapper

	domenu "${PN}.desktop"
	doicon "${PN}.png"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
