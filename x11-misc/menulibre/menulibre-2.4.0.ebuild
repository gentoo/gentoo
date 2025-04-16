# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"
inherit distutils-r1 xdg

DESCRIPTION="Advanced freedesktop.org compliant menu editor"
HOMEPAGE="https://bluesabre.org/projects/menulibre"
SRC_URI="https://github.com/bluesabre/menulibre/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	gnome-base/gnome-menus:3[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-themes/hicolor-icon-theme
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	')
	dev-util/intltool
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# show desktop entry in all DEs
	sed -i '/^OnlyShowIn/d' menulibre.desktop.in || die

	# workaround incorrect behavior when LINGUAS is set to an empty string
	# https://bugs.launchpad.net/python-distutils-extra/+bug/1133594
	! [[ -v LINGUAS && -z ${LINGUAS} ]] || rm po/*.po || die
}

python_install_all() {
	distutils-r1_python_install_all

	rm -r "${ED}"/usr/share/doc/${PN} || die
}
