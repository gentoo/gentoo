# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
inherit gnome2-utils xdg distutils-r1

DESCRIPTION="Linux alternative to EyeLeo"
HOMEPAGE="https://github.com/slgobinath/SafeEyes"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="${PYTHON_DEPS}"
DEPEND="${CDEPEND}
	>=dev-python/setuptools-38.6.0[${PYTHON_USEDEP}]
	"
RDEPEND="${CDEPEND}
	dev-libs/libappindicator:3
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	media-sound/alsa-utils
	x11-apps/xprop
	x11-misc/xprintidle
	"

DOCS=(
	README.md
)

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
