# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1 optfeature virtualx xdg-utils

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="https://github.com/gnome-terminator/terminator"
SRC_URI="https://github.com/gnome-terminator/terminator/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

RDEPEND="
	dev-libs/glib:2
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-base/gsettings-desktop-schemas[introspection]
	x11-libs/gtk+:3
	x11-libs/vte:2.91[introspection]
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	test? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		x11-libs/libnotify[introspection]
	)
"
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/terminator-1.91-without-icon-cache.patch
	"${FILESDIR}"/terminator-1.91-desktop.patch
)

src_prepare() {
	xdg_environment_reset
	sed -i -e '/pytest-runner/d' setup.py || die
	distutils-r1_src_prepare
}

src_test() {
	virtx distutils-r1_src_test
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	optfeature "D-Bus" dev-python/dbus-python
	optfeature "desktop notifications" "x11-libs/libnotify[introspection]"
	optfeature "global keyboard shortcuts" "dev-libs/keybinder:3[introspection]"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
