# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYPI_NO_NORMALIZE=1
PYPI_PN="wxPython"
WX_GTK_VER="3.2-gtk3"

inherit distutils-r1 multiprocessing virtualx wxwidgets pypi

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="
	https://www.wxpython.org/
	https://github.com/wxWidgets/Phoenix/
	https://pypi.org/project/wxPython/
"

LICENSE="wxWinLL-3"
SLOT="4.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test webkit"
RESTRICT="!test? ( test )"

# wxPython doesn't seem to be able to optionally disable features. webkit is
# optionally patched out because it's so huge, but other elements are not,
# which makes us have to require all features from wxGTK
DEPEND="
	>=x11-libs/wxGTK-3.2.7:${WX_GTK_VER}=[gstreamer,libnotify,opengl,sdl,tiff,webkit?,X]
	media-libs/libpng:=
	media-libs/tiff:=
	media-libs/libjpeg-turbo:=
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	app-text/doxygen
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-python/sip-6.8.5[${PYTHON_USEDEP}]
	test? (
		${VIRTUALX_DEPEND}
		dev-python/appdirs[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-flags.patch"
	"${FILESDIR}/${PN}-4.2.1-x86-time.patch"
	"${FILESDIR}/${PN}-4.2.2-setuppy.patch"
)

python_prepare_all() {
	if ! use webkit; then
		eapply "${FILESDIR}/${PN}-4.2.0-no-webkit.patch"
	fi

	local build_options="build_py --use_syswx --no_magic --jobs=$(makeopts_jobs) --verbose --release"

	DISTUTILS_ARGS=(
		--verbose
		build
		--buildpy-options="${build_options}"
	)

	distutils-r1_python_prepare_all

	# sigh
	sed -i -e '/from buildtools/i\
sys.path.insert(0, ".")' setup.py || die
}

src_configure() {
	setup-wxwidgets
}

python_compile() {
	# Patch will fail if copy of refreshed sip file is not restored
	# if using multiple Python implementations
	DOXYGEN="$(type -P doxygen)" ${PYTHON} build.py dox etg sip --nodoc || die
	cp "${S}/sip/cpp/sip_corewxAppTraits.cpp" "${S}" || die

	eapply "${FILESDIR}/${PN}-4.2.2-no-stacktrace.patch" || die

	distutils-r1_python_compile

	cp "${S}/sip_corewxAppTraits.cpp" "${S}/sip/cpp/" || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# virtx probably
		unittests/test_display.py::display_Tests::test_display
		unittests/test_frame.py::frame_Tests::test_frameRestore
		unittests/test_mousemanager.py::mousemanager_Tests::test_mousemanager1
		unittests/test_uiaction.py::uiaction_KeyboardTests::test_uiactionKeyboardChar
		unittests/test_uiaction.py::uiaction_KeyboardTests::test_uiactionKeyboardKeyDownUp
		unittests/test_uiaction.py::uiaction_MouseTests

		# assertion (TODO)
		unittests/test_aboutdlg.py::aboutdlg_Tests::test_aboutdlgGeneric
		unittests/test_lib_agw_piectrl.py::lib_agw_piectrl_Tests::test_lib_agw_piectrlCtor

		# seems to rely on state from a previous test (sigh)
		unittests/test_lib_agw_persist_persistencemanager.py::lib_agw_persist_persistencemanager_Tests::test_persistencemanagerRestore

		# requires Spanish localization
		unittests/test_intl.py::intl_Tests::test_intlGetString

		# TODO
		unittests/test_tipwin.py::tipwin_Tests::test_tipwinCtor
		unittests/test_lib_pubsub_provider.py::lib_pubsub_Except::test1
		unittests/test_windowid.py::IdManagerTest::test_newIdRef03
	)
	local EPYTEST_IGNORE=()
	if ! use webkit; then
		EPYTEST_IGNORE+=( unittests/test_webview.py )
	fi

	# We use pytest-forked as opensuse does to avoid tests corrupting each
	# other.
	virtx epytest --forked unittests
}
