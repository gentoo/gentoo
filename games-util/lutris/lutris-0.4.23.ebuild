# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="An open source gaming platform for GNU/Linux"
HOMEPAGE="https://lutris.net/"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/lutris/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/lutris/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-evdev[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	net-libs/libsoup
	x11-apps/xrandr
	x11-apps/xgamma"

src_install() {
	distutils-r1_src_install
	newdoc debian/changelog CHANGELOG
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update

	elog "For a list of optional dependencies (runners) see:"
	elog "/usr/share/doc/${PF}/README.rst.bz2"
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
