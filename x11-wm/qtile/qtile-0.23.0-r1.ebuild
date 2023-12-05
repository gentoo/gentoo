# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A full-featured, hackable tiling window manager written in Python"
HOMEPAGE="
	https://qtile.org/
	https://github.com/qtile/qtile/
	https://pypi.org/project/qtile/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
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
		>=dev-python/pywlroots-0.16[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		media-gfx/imagemagick[X]
		x11-base/xorg-server[xephyr,xvfb]
	)
	wayland? (
		>=dev-python/pywlroots-0.16[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	local PATCHES=(
		# https://github.com/qtile/qtile/pull/4610
		"${FILESDIR}/${P}-keyring.patch"
	)

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

python_test() {
	local EPYTEST_DESELECT=(
		# mocking doesn't seem to work
		test/widgets/test_mpd2widget.py
		# checks fail with mypy errors
		test/test_check.py
		# migration tests require intact source tree
		test/test_migrate.py
		# no clue ("ExistingWMException")
		test/test_restart.py::test_restart_hook_and_state
	)

	# force usage of built module
	rm -rf libqtile || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
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
