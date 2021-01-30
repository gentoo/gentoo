# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit meson python-single-r1 udev

DESCRIPTION="GTK configuration application for libratbag"
HOMEPAGE="https://github.com/libratbag/piper"
SRC_URI="https://github.com/libratbag/piper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/gobject-introspection
	>=dev-libs/libratbag-0.13
	gnome-base/librsvg[introspection]
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_MULTI_USEDEP}]
		dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		dev-python/python-evdev[${PYTHON_MULTI_USEDEP}]
	')
"
DEPEND="
	${RDEPEND}
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
