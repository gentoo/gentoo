# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson python-single-r1 xdg

DESCRIPTION="GTK application to configure gaming devices"
HOMEPAGE="https://github.com/libratbag/piper"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libratbag/piper.git"
else
	SRC_URI="https://github.com/libratbag/piper/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_USEDEP}]
	')
	virtual/pkgconfig
	test? ( dev-libs/appstream )
"
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/gobject-introspection
	>=dev-libs/libratbag-0.18
	gnome-base/librsvg[introspection]
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	$(python_gen_cond_dep '
		dev-python/evdev[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
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
