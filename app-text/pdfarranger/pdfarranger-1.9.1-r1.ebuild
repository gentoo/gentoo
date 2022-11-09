# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..11} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 optfeature xdg desktop

DESCRIPTION="Merge or split pdfs; rearrange, rotate, crop pages"
HOMEPAGE="https://github.com/jeromerobert/pdfarranger"
SRC_URI="https://github.com/jeromerobert/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-text/poppler[introspection,cairo]
	>=dev-python/pikepdf-6.0.0[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${RDEPEND}
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	dev-util/intltool
"

src_install() {
	distutils-r1_src_install
	for x in 16 32 48 256 scalable
	do doicon -s ${x} data/icons/hicolor/${x}*/*
	done
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "image file import" media-gfx/img2pdf
}
