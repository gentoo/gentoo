# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit meson python-r1 xdg-utils

DESCRIPTION="A Python Interface to GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=media-libs/gstreamer-${PV}:1.0[introspection]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection]
	>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	# Avoid building & testing plugin - it must NOT be multi-python as gst-inspect will map in all libpython.so versions and crash or behave mysteriously.
	# Python plugin support is of limited use (GIL gets in the way). If it's ever requested or needed, it should be a
	# separate python-single-r1 media-plugins/gst-plugins-python package that only builds the plugin directory.
	sed -e '/subdir.*plugin/d' -i meson.build || die
	sed -e '/test_plugin.py/d' -i testsuite/meson.build || die

	xdg_environment_reset
}

src_configure() {
	configuring() {
		meson_src_configure \
			-Dpython="${EPYTHON}"
	}
	python_foreach_impl configuring
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	python_foreach_impl meson_src_test
}

src_install() {
	installing() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl installing
}
