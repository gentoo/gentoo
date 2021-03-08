# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1 optfeature verify-sig virtualx xdg-utils

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="https://github.com/gnome-terminator/terminator"
SRC_URI="
	https://github.com/gnome-terminator/terminator/releases/download/v${PV}/${P}.tar.gz
	verify-sig? ( https://github.com/gnome-terminator/terminator/releases/download/v${PV}/${P}.tar.gz.asc )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
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
	verify-sig? ( app-crypt/openpgp-keys-terminator )
"
distutils_enable_tests pytest

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/terminator.asc

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

	elog "Consider installing the following for additional features:"
	optfeature "D-Bus" dev-python/dbus-python
	optfeature "Desktop notifications" "x11-libs/libnotify[introspection]"
	optfeature "Global keyboard shortcuts" "dev-libs/keybinder:3[introspection]"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
