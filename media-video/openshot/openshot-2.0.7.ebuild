# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_REQ_USE=xml
PYTHON_COMPAT=( python3_{4,5} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils versionator xdg

MY_PN="${PN}-qt"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Free, open-source, non-linear video editor to create and edit videos and movies"
HOMEPAGE="http://www.openshot.org/ https://launchpad.net/libopenshot"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="1"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/PyQt5[webkit,${PYTHON_USEDEP}]
	media-libs/libopenshot[python,${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}"

src_prepare() {
	# prevent setup.py from trying to update MIME databases
	sed -i 's/^ROOT =.*/ROOT = False/' setup.py || die
	xdg_src_prepare
	distutils-r1_python_prepare_all
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
