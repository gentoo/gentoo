# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit meson python-r1 udev

DESCRIPTION="GTK configuration application for libratbag"
HOMEPAGE="https://github.com/libratbag/piper"
SRC_URI="https://github.com/libratbag/piper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	dev-libs/libratbag
	dev-python/python-evdev[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/libevdev
	virtual/libudev
"

src_configure() {
	python_setup
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
	python_fix_shebang "${ED}"/usr/bin/
}
