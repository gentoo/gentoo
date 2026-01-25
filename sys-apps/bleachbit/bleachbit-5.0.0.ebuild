# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="sqlite(+)"
DISTUTILS_SINGLE_IMPL=1

inherit desktop distutils-r1 virtualx

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="https://www.bleachbit.org"
SRC_URI="https://download.bleachbit.org/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3[introspection]
"
BDEPEND="
	sys-devel/gettext
"

distutils_enable_tests unittest

python_prepare_all() {
	if use test; then
		# avoid tests requiring internet access
		rm tests/Test{Chaff,GuiChaff,Network,Update}.py || die

		sed -e "s/test_chaff(self)/_&/" \
			-i tests/TestGUI.py || die

		# fails due to invalid language code format pt_pt
		sed -e "s/test_assertIsLanguageCode_live(self)/_&/" \
			-i tests/TestCommon.py || die

		# fails due to non-existent $HOME/.profile
		rm tests/TestInit.py || die

		# fails due to permission error on /proc
		sed -e "s/test_make_self_oom_target_linux(self)/_&/" \
			-i tests/TestMemory.py || die

		# only applicable to Windows
		rm tests/{TestNsisUtilities,TestWindows}.py || die

		# random failures, some also on upstream CI
		sed -e "s/test_notify(self)/_&/" \
			-i tests/TestGUI.py || die

		sed -e "s/test_get_proc_swaps(self)/_&/" \
			-i tests/TestMemory.py || die

		sed -e "s/test_is_process_running(self)/_&/" \
			-i tests/TestUnix.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C po local
}

python_test() {
	virtx emake tests
}

python_install() {
	distutils-r1_python_install
	python_newscript ${PN}.py ${PN}
}

python_install_all() {
	distutils-r1_python_install_all
	emake -C po DESTDIR="${D}" install

	insinto /usr/share/bleachbit/cleaners
	doins cleaners/*.xml

	insinto /usr/share/bleachbit
	doins data/app-menu.ui

	doicon ${PN}.png
	domenu org.${PN}.BleachBit.desktop
}
