# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.asc
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="sqlite(+)"

inherit desktop distutils-r1 toolchain-funcs verify-sig virtualx

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
BDEPEND="
	sys-devel/gettext
	test? (
		gnome-base/dconf
		sys-apps/dbus
	)
	verify-sig? ( sec-keys/openpgp-keys-bleachbit )
"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}"/${P}-fix_locale_test.patch
	"${FILESDIR}"/${PN}-6.0.0-noupdate.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	if use test; then
		sed -e "s:'strings':'$(tc-getSTRINGS)':g" \
			-i tests/TestWipePath.py || die

		# avoid tests requiring internet access
		rm tests/Test{Chaff,GuiChaff,Network,Update}.py || die

		sed -e "s/test_chaff(self)/_&/" \
			-i tests/TestGUI.py || die

		# incorrectly parses all locale dirs or alias, including non-POSIX locales (e.g. es_419),
		# even though Bleachbit only validates POSIX locales
		# see https://bugs.gentoo.org/978295
		sed -e "s/test_assertIsLanguageCode_live(self)/_&/" \
			-i tests/TestCommon.py || die

		# fails due to non-existent $HOME/.profile
		rm tests/TestInit.py || die

		# fails due to permission error on /proc
		sed -e "s/test_make_self_oom_target_linux(self)/_&/" \
			-i tests/TestMemory.py || die

		# only applicable to Windows
		rm tests/{TestNsisUtilities,TestWindows}.py || die

		# slow test (50s)
		sed -e "s/test_notify(self)/_&/" \
			-i tests/TestGUI.py || die

		# random failures, some also on upstream CI
		sed -e "s/test_get_proc_swaps(self)/_&/" \
			-i tests/TestMemory.py || die

		sed -e "s/test_is_process_running(self)/_&/" \
			-i tests/TestUnix.py || die

		# Fails if user has filesystems outside of the accepted subset
		# ['btrfs', 'ext4', 'ext3', 'squashfs', 'unknown']
		# This is an issue for example if you use xfs.
		# Instead of adding every possible filesystem lets just skip it.
		sed -e "s/test_get_filesystem_type(self)/_&/" \
			-i tests/TestFileUtilities.py || die

		# Assumes loginshell is the uid.
		sed -e "s/test_get_real_uid(self)/_&/" \
			-i tests/TestGeneral.py || die
	fi
}

python_compile_all() {
	emake -C po local
}

python_test() {
	# use a hardcoded valid code, some tests may fail with accent (pt, fr, ck ...)
	# tests.TestGuiStartup.GuiStartupTestCase.test_first_start_message_clears_flag
	# tests.TestGuiStartup.GuiStartupTestCase.test_upgrade_message_shown_for_pre_510
	# tests.TestWinapp.WinappTestCase.test_section_not_found
	export LC_ALL="C.UTF-8"
	virtx dbus-run-session "${EPYTHON}" -m unittest discover -v -p Test*.py || die "tests failed with ${EPYTHON}"
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
	domenu org.${PN}.BleachBit.desktop
}
