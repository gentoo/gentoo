# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit xdg distutils-r1

DESCRIPTION="Linux alternative to EyeLeo"
HOMEPAGE="https://github.com/slgobinath/SafeEyes"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

RDEPEND="
	dev-libs/libappindicator:3[introspection]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/croniter[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	media-sound/alsa-utils
	x11-apps/xprop
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	x11-misc/xprintidle
	"

DOCS=(
	README.md
)

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
