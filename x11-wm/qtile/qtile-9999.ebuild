# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 virtualx

DESCRIPTION="A full-featured, hackable tiling window manager written in Python"
HOMEPAGE="http://www.qtile.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/qtile/qtile.git"
else
	inherit pypi
	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="pulseaudio wayland"

# See bug #895722 and https://github.com/qtile/qtile/pull/3985 regarding
# pywlroots-0.15 dep.
RDEPEND="
	>=dev-python/cairocffi-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.1.0[${PYTHON_USEDEP}]
	dev-python/dbus-next[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/xcffib-1.4.0[${PYTHON_USEDEP}]
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libnotify[introspection]
	x11-libs/pango
	pulseaudio? ( media-libs/libpulse )
	wayland? ( =dev-python/pywlroots-0.15*[${PYTHON_USEDEP}] )
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		media-gfx/imagemagick[X]
		x11-base/xorg-server[xephyr]
	)
"

EPYTEST_DESELECT=(
	# Can't find built qtile like migrate
	test/test_qtile_cmd.py::test_qtile_cmd
	test/test_qtile_cmd.py::test_display_kb
)

EPYTEST_IGNORE=(
	# Tries to find binary and fails; not worth running anyway?
	test/test_migrate.py
)

distutils_enable_tests pytest

python_prepare_all() {
	# Avoid automagic dependency on libpulse
	if ! use pulseaudio ; then
		sed -i -e 's/call("libpulse", "--libs")/raise PkgConfigError/' setup.py || die
	fi

	# Avoid automagic dependency on pywlroots
	if ! use wayland ; then
		sed -i -e 's/import wlroots.ffi_build/raise ImportError/' setup.py || die
	fi

	distutils-r1_python_prepare_all
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	# Force usage of built module
	rm -rf "${S}"/libqtile || die

	# TODO: remove "-p no:xdist" for next release when https://github.com/qtile/qtile/issues/1634 will be resolved.
	epytest -p no:xdist --backend=x11 $(usev wayland '--backend=wayland') || die "Tests failed with ${EPYTHON}"
}

python_compile() {
	export CFFI_TMPDIR=${T}
	distutils-r1_python_compile
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
