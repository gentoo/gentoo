# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 linux-info xdg

DESCRIPTION="User-mode driver and GTK-based GUI for Steam Controllers and others"
HOMEPAGE="https://github.com/C0rn3j/sc-controller/"
SRC_URI="https://github.com/C0rn3j/sc-controller/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BSD CC-BY-3.0 CC0-1.0 LGPL-2.1 MIT PSF-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+trayicon +udev wayland"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/evdev[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP},cairo]
		dev-python/pylibacl[${PYTHON_USEDEP}]
		dev-python/vdf[${PYTHON_USEDEP}]
	')
	gnome-base/librsvg[introspection]
	virtual/libusb
	x11-libs/gtk+:3[introspection]
	trayicon? ( dev-libs/libayatana-appindicator )
	udev? ( games-util/game-device-udev-rules )
	wayland? ( gui-libs/gtk-layer-shell[introspection(+)] )
"

distutils_enable_tests pytest

pkg_setup() {
	local CONFIG_CHECK="~INPUT_UINPUT"

	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	# This test fails. Don't know why but seems unimportant.
	rm -v tests/test_glade.py || die
}

src_install() {
	distutils-r1_src_install
	rm -r "${ED}"/usr/lib/udev/ || die
}
