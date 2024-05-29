# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="A full-featured, hackable tiling window manager written in Python"
HOMEPAGE="
	https://qtile.org/
	https://github.com/qtile/qtile/
	https://pypi.org/project/qtile/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="pulseaudio wayland"

RDEPEND="
	>=dev-python/cairocffi-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]
	dev-python/dbus-next[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	>=dev-python/xcffib-1.4.0[${PYTHON_USEDEP}]
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libnotify[introspection]
	x11-libs/pango
	pulseaudio? (
		dev-python/pulsectl-asyncio[${PYTHON_USEDEP}]
		media-sound/pulseaudio
	)
	wayland? (
		>=dev-python/pywayland-0.4.17[${PYTHON_USEDEP}]
		>=dev-python/pywlroots-0.17[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/libcst[${PYTHON_USEDEP}]
		media-gfx/imagemagick[X]
		x11-base/xorg-server[xephyr,xvfb]
	)
	wayland? (
		>=dev-python/pywayland-0.4.17[${PYTHON_USEDEP}]
		>=dev-python/pywlroots-0.17[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e "s/can_import(\"wlroots.ffi_build\")/$(usex wayland True False)/" \
		-i setup.py || die

	# some tests expect bin/qtile
	mkdir bin || die
	cat >> bin/qtile <<-EOF || die
		#!/bin/sh
		exec qtile "\${@}"
	EOF
	chmod +x bin/qtile || die

	distutils-r1_python_prepare_all
}

src_compile() {
	local -x CFFI_TMPDIR=${T}
	distutils-r1_src_compile
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# mypy stuff
		test/test_check.py
		test/migrate/test_check_migrations.py
		# TODO: this test clearly requires x11 — so why is wayland
		# variant being run?
		'test/backend/x11/test_window.py::test_urgent_hook_fire[wayland-2]'
	)

	# force usage of built module
	rm -rf libqtile || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x TZ=UTC
	nonfatal epytest --backend=x11 $(usev wayland '--backend=wayland') ||
		die -n "Tests failed with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGELOG README.rst )
	distutils-r1_python_install_all

	insinto /usr/share/xsessions
	doins resources/qtile.desktop

	insinto /usr/share/wayland-sessions
	doins resources/qtile-wayland.desktop

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session-r1 ${PN}
}
