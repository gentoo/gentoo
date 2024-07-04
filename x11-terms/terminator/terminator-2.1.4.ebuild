# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 optfeature verify-sig virtualx xdg

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="https://github.com/gnome-terminator/terminator"
SRC_URI="
	https://github.com/gnome-terminator/terminator/releases/download/v${PV}/${P}.tar.gz
	verify-sig? ( https://github.com/gnome-terminator/terminator/releases/download/v${PV}/${P}.tar.gz.asc )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
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
	verify-sig? ( sec-keys/openpgp-keys-terminator )
"
distutils_enable_tests pytest

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/terminator.asc

PATCHES=(
	"${FILESDIR}"/terminator-1.91-desktop.patch
)

src_test() {
	virtx distutils-r1_src_test
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "D-Bus" dev-python/dbus-python
	optfeature "desktop notifications" "x11-libs/libnotify[introspection]"
	optfeature "global keyboard shortcuts" "dev-libs/keybinder:3[introspection]"
}
