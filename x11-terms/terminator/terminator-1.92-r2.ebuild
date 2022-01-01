# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS="no"
inherit distutils-r1 virtualx xdg-utils

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="https://github.com/gnome-terminator/terminator"
SRC_URI="https://github.com/gnome-terminator/terminator/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="dbus +libnotify X"

RDEPEND="
	dev-libs/glib:2
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3
	x11-libs/vte:2.91[introspection]
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	libnotify? ( x11-libs/libnotify[introspection] )
	X? ( dev-libs/keybinder:3[introspection] )
"
BDEPEND="
	dev-util/intltool
"
distutils_enable_tests setup.py

PATCHES=(
	"${FILESDIR}"/terminator-1.91-without-icon-cache.patch
	"${FILESDIR}"/terminator-1.91-desktop.patch
	"${FILESDIR}"/terminator-1.92-make-tests-fail.patch
	"${FILESDIR}"/terminator-1.92-metainfo.patch
)

src_prepare() {
	xdg_environment_reset
	distutils-r1_src_prepare
}

src_test() {
	virtx distutils-r1_src_test
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
