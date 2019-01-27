# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="A frontend for find, (s)locate, doodle, tracker, beagle, strigi and pinot"
HOMEPAGE="https://docs.xfce.org/apps/catfish/start"
SRC_URI="https://archive.xfce.org/src/apps/catfish/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	virtual/freedesktop-icon-theme
"
DEPEND="
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	sys-devel/gettext
"

python_install() {
	distutils-r1_python_install
	rm -r "${ED%/}"/usr/share/doc/catfish || die
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
