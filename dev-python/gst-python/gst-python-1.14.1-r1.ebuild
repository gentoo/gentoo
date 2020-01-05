# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit ltprune python-r1 xdg-utils

DESCRIPTION="A Python Interface to GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[introspection]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	xdg_environment_reset
	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir econf
}

src_compile() {
	# Avoid building plugin - it must NOT be multi-python as gst-inspect will map in all libpython.so versions and crash or behave mysteriously.
	# Python plugin support is of limited use (GIL gets in the way). If it's ever requested or needed, it should be a
	# separate python-single-r1 media-plugins/gst-plugins-python package that only builds the plugin directory.
	compile_gst() {
		emake -C common
		emake -C gi
		emake -C testsuite
	}
	python_foreach_impl run_in_build_dir compile_gst
}

src_install() {
	install_gst() {
		emake DESTDIR="${D}" install -C common
		emake DESTDIR="${D}" install -C gi
		emake DESTDIR="${D}" install -C testsuite
	}
	python_foreach_impl run_in_build_dir install_gst
	prune_libtool_files --modules
	einstalldocs
}

src_test() {
	test_gst() {
		emake check -C testsuite
	}
	python_foreach_impl run_in_build_dir default
}
