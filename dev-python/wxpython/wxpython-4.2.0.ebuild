# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_IN_SOURCE_BUILD="1"
PYTHON_COMPAT=( python3_{9..11} )
WX_GTK_VER="3.2-gtk3"

inherit distutils-r1 multiprocessing virtualx wxwidgets

MY_PN="wxPython"
MY_PV="${PV/_p/.post}"

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="https://www.wxpython.org/"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="4.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test webkit"
# Tests broken: #726812, #722716
# Nearly there as of 4.2.0 but still quite flaky (inconsistent set of failures)
RESTRICT="!test? ( test ) test"

# wxPython doesn't seem to be able to optionally disable features. webkit is
# optionally patched out because it's so huge, but other elements are not,
# which makes us have to require all features from wxGTK
RDEPEND="
	>=x11-libs/wxGTK-3.0.4-r301:${WX_GTK_VER}=[gstreamer,libnotify,opengl,sdl,tiff,webkit?,X]
	media-libs/libpng:=
	media-libs/tiff:=
	media-libs/libjpeg-turbo:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-doc/doxygen
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/sip-6.6.2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	test? (
		${VIRTUALX_DEPEND}
		dev-python/appdirs[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

PATCHES=(
	#"${FILESDIR}/${PN}-4.0.6-skip-broken-tests.patch"
	"${FILESDIR}/${PN}-4.2.0-no-attrdict.patch"
	"${FILESDIR}/${PN}-4.2.0-flags.patch"
)

python_prepare_all() {
	if ! use webkit; then
		eapply "${FILESDIR}/${PN}-4.2.0-no-webkit.patch"
		rm unittests/test_webview.py || die
	fi

	# Most of these tests disabled below fail because of the virtx/portage
	# environment, but some fail for unknown reasons.
	rm unittests/test_uiaction.py \
		unittests/test_notifmsg.py \
		unittests/test_mousemanager.py \
		unittests/test_display.py \
		unittests/test_pi_import.py \
		unittests/test_lib_agw_thumbnailctrl.py \
		unittests/test_sound.py || die

	distutils-r1_python_prepare_all
}

src_configure() {
	setup-wxwidgets
}

python_compile() {
	DOXYGEN=/usr/bin/doxygen ${PYTHON} build.py dox etg --nodoc || die

	# Refresh the bundled/pregenerated sip files
	${PYTHON} build.py sip || die

	# Build the bindings
	${PYTHON} build.py build_py \
		--use_syswx \
		--no_magic \
		--jobs="$(makeopts_jobs)" \
		--verbose \
		--release || die
}

python_test() {
	EPYTEST_DESELECT=(
		# Aborts, needs investigation
		unittests/test_utils.py::utils_Tests::test_utilsSomeOtherStuff

		# Failures, need investigation
		unittests/test_frame.py::frame_Tests::test_frameRestore
		unittests/test_fswatcher.py::fswatcher_Tests::test_fswatcher1
		unittests/test_intl.py::intl_Tests::test_intlGetString
		unittests/test_lib_busy.py::lib_busy_Tests::test_lib_busy5
		unittests/test_lib_mixins_inspection.py::wit_TestCase::test_App_OnInit
		unittests/test_lib_pubsub_provider.py::lib_pubsub_Except::test1
		unittests/test_lib_pubsub_topicmgr.py::lib_pubsub_TopicMgr2_GetOrCreate_DefnProv::test20_UseProvider
		unittests/test_windowid.py::IdManagerTest::test_newIdRef03
		unittests/test_auibook.py::auibook_Tests::test_auibook02
		unittests/test_lib_agw_persist_persistencemanager.py::lib_agw_persist_persistencemanager_Tests::test_persistencemanagerPersistValue
		unittests/test_lib_agw_persist_persistencemanager.py::lib_agw_persist_persistencemanager_Tests::test_persistencemanagerRestore
		unittests/test_aboutdlg.py::aboutdlg_Tests::test_aboutdlgGeneric
		unittests/test_auiframemanager.py::auiframemanager_Tests::test_auiframemanager02
	)

	# We use pytest-forked as opensuse does to avoid tests corrupting each
	# other.
	virtx epytest --forked -n "$(makeopts_jobs)" unittests
}

python_install() {
	distutils-r1_python_install --skip-build
}
