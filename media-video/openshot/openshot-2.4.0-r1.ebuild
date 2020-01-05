# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_REQ_USE=xml
PYTHON_COMPAT=( python3_6 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils versionator xdg-utils

MY_PN="${PN}-qt"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Free, open-source, non-linear video editor to create and edit videos and movies"
HOMEPAGE="https://www.openshot.org/ https://launchpad.net/openshot"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="1"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},svg,webkit]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=media-libs/libopenshot-0.1.8[python,${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# prevent setup.py from trying to update MIME databases
	sed -i 's/^ROOT =.*/ROOT = False/' setup.py || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
