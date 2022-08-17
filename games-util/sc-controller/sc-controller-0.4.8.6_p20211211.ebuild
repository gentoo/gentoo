# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 linux-info xdg

COMMIT="3ce2d23c873f6f5ecc80ef90f153c14f744368f9"
DESCRIPTION="User-mode driver and GTK-based GUI for Steam Controllers and others"
HOMEPAGE="https://github.com/Ryochan7/sc-controller/"
SRC_URI="https://github.com/Ryochan7/sc-controller/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BSD CC-BY-3.0 CC0-1.0 LGPL-2.1 MIT PSF-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+udev"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_USEDEP},cairo]
		dev-python/pylibacl[${PYTHON_USEDEP}]
		dev-python/python-evdev[${PYTHON_USEDEP}]
		dev-python/vdf[${PYTHON_USEDEP}]')
	gnome-base/librsvg[introspection]
	virtual/libusb
	x11-libs/gtk+:3[introspection]
	udev? ( games-util/game-device-udev-rules )"

distutils_enable_tests pytest

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-bluetooth-evdev.patch
)

pkg_setup() {
	local CONFIG_CHECK="~INPUT_UINPUT"

	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install
	rm -r "${ED}"/usr/lib/udev/ || die
}
