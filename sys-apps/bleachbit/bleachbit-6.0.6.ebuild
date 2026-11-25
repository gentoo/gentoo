# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.asc
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="sqlite(+)"

inherit desktop distutils-r1 toolchain-funcs verify-sig virtualx xdg

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="https://www.bleachbit.org"
SRC_URI="
	https://download.bleachbit.org/${P}.tar.bz2
	verify-sig? (
		https://download.sourceforge.net/project/bleachbit/bleachbit/${PV}/detached_signatures/${P}.tar.bz2.sig
	)
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
	')
	dev-libs/glib:2[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	x11-libs/pango[introspection]
"
# see https://bugs.gentoo.org/978295
# force sys-apps/dbus[X] to call epytest instead of "${EPYTHON}" -m pytest
BDEPEND="
	sys-devel/gettext
	test? (
		gnome-base/dconf
		sys-apps/dbus[X]
	)
	verify-sig? ( sec-keys/openpgp-keys-bleachbit )
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.0-noupdate.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	if use test; then
		sed -e "s:'strings':'$(tc-getSTRINGS)':g" \
			-i tests/TestWipePath.py || die
	fi
}

python_compile_all() {
	emake -C po local
}

python_test() {
	local EPYTEST_DESELECT=(
		# avoid tests requiring internet access
		tests/TestGUI.py::GUITestCase::test_chaff

		# fails due to permission error on /proc
		tests/TestMemory.py::MemoryTestCase::test_make_self_oom_target_linux

		# random failures, some also on upstream CI
		tests/TestMemory.py::MemoryTestCase::test_get_proc_swaps

		# incorrectly parses all locale dirs or alias, including non-POSIX locales (e.g. es_419),
		# even though Bleachbit only validates POSIX locales
		# see https://bugs.gentoo.org/978295
		tests/TestCommon.py::CommonTestCase::test_assertIsLanguageCode_live

		# slow test (50s)
		tests/TestGUI.py::GUITestCase::test_notify

		# Permission errors
		tests/TestProcess.py::ProcessTestCase::test_is_process_running_linux
		tests/TestProcess.py::ProcessTestCase::test_is_process_running_self

		# Assumes loginshell is the uid.
		tests/TestGeneral.py::GeneralTestCase::test_get_real_uid
		tests/TestGuiCookie.py::GuiCookieTestCase::test_save_changes_still_works
		tests/TestGuiStartup.py::GuiStartupTestCase::test_config_permission_issues_normal
		tests/TestGuiStartup.py::GuiStartupTestCase::test_config_permission_missing_file_sudo_chown
		tests/TestGuiStartup.py::GuiStartupTestCase::test_config_permission_nonissue_missing_dir
		tests/TestGuiStartup.py::GuiStartupTestCase::test_config_permission_nonissue_missing_file
		tests/TestGuiStartup.py::GuiStartupTestCase::test_permission_issues_normal_file

		# Fails if user has filesystems outside of the accepted subset
		# ['btrfs', 'ext4', 'ext3', 'squashfs', 'unknown']
		# This is an issue for example if you use xfs.
		# Instead of adding every possible filesystem lets just skip it.
		tests/TestFileUtilities.py::FileUtilitiesTestCase::test_get_filesystem_type

		# Tests done through /var and may conflict with tempfiles in /var/tmp/portage
		# see https://bugs.gentoo.org/987253
		tests/TestAction.py::ActionTestCase::test_walk_files
		tests/TestCleanerML.py::CleanerMLTestCase::test_CleanerML
		tests/TestCLI.py::CLITestCase.test_delete

		# Permission errors while mounting
		# see https://bugs.gentoo.org/987253
		tests/TestFileUtilities.py::FileUtilitiesTestCase::test_delete_mount_point
		tests/TestWipePath.py::WipePathTestCase::test_wipe
	)

	local EPYTEST_IGNORE=(
		# avoid tests requiring internet access
		tests/Test{Chaff,GuiChaff,Network,Update}.py

		# fails due to non-existent $HOME/.profile
		tests/TestInit.py

		# only applicable to Windows
		tests/{TestNsisUtilities,TestWindows}.py
	)

	# use a hardcoded valid code, some tests may fail with accent (pt, fr, ck ...)
	# GuiStartupTestCase::test_first_start_message_clears_flag
	# GuiStartupTestCase::test_upgrade_message_shown_for_pre_510
	# WinappTestCase::test_section_not_found
	export LC_ALL="C.UTF-8"
	virtx epytest -m 'not no_xdist'
}

python_install() {
	distutils-r1_python_install
	python_newscript ${PN}.py ${PN}
}

python_install_all() {
	# reproduce the install phase from Makefile, not adapted for python_sitedir
	distutils-r1_python_install_all
	emake -C po DESTDIR="${D}" install

	insinto /usr/share/bleachbit/cleaners
	doins cleaners/*.xml

	insinto /usr/share/bleachbit
	doins share/*

	insinto /usr/share/metainfo
	doins org.bleachbit.BleachBit.metainfo.xml

	insinto /usr/share/polkit-1/actions
	doins org.bleachbit.policy

	dodoc doc/*

	doicon ${PN}.png
	doicon -s scalable ${PN}.svg
	domenu org.${PN}.BleachBit.desktop
}
