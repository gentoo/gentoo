# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYPI_VERIFY_REPO=https://github.com/qtile/qtile
PYTHON_COMPAT=( python3_13 )

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

DEPEND="
	>=dev-python/cairocffi-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]
	wayland? (
		dev-libs/libinput:=
		dev-libs/wayland
		gui-libs/wlroots:0.19
	)
"
RDEPEND="
	${DEPEND}
	dev-python/dbus-fast[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	>=dev-python/xcffib-1.4.0[${PYTHON_USEDEP}]
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libnotify[introspection]
	x11-libs/pango
	pulseaudio? (
		dev-python/pulsectl-asyncio[${PYTHON_USEDEP}]
		media-libs/libpulse
	)
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/libcst[${PYTHON_USEDEP}]
		media-gfx/imagemagick[X]
		x11-base/xorg-server[xephyr,xvfb]
		x11-terms/xterm
	)
	wayland? (
		>=dev-python/pywayland-0.4.17[${PYTHON_USEDEP}]
		>=dev-python/pywlroots-0.17[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( anyio pytest-asyncio )
EPYTEST_RERUNS=5
: ${EPYTEST_TIMEOUT:=180}
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# make extension builds fatal
	sed -i -e 's:Exception:None:' builder.py || die

	if ! use wayland; then
		sed -e "s/ffi_compile(verbose=wayland_requested)/pass/" \
			-i builder.py || die
	fi

	mkdir bin || die
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
		# Internet
		test/widgets/test_generic_poll_text.py::test_gen_poll_url_text
		test/widgets/test_generic_poll_text.py::test_gen_poll_url_json_with_data
		test/widgets/test_generic_poll_text.py::test_gen_poll_url_custom_headers
	)

	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	cp -R "${S}/test" . || die

	local -x TZ=UTC
	nonfatal epytest --backend=x11 $(usev wayland '--backend=wayland')
	local ret=${?}
	rm -rf test || die

	[[ ${ret} -eq 0 ]] || die -n "Tests failed with ${EPYTHON}"
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
