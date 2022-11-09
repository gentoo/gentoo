# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
PYTHON_REQ_USE="sqlite(+)"
DISTUTILS_SINGLE_IMPL=1

inherit desktop distutils-r1 virtualx

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="https://www.bleachbit.org"
SRC_URI="https://download.bleachbit.org/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3
"
BDEPEND="
	sys-devel/gettext
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]')
	)
"

distutils_enable_tests unittest

# tests fail under FEATURES=usersandbox
RESTRICT="test"

python_prepare_all() {
	if use test; then
		# avoid tests requiring internet access
		rm tests/Test{Chaff,Update}.py || die

		# fails due to non-existent $HOME/.profile
		rm tests/TestInit.py || die

		# only applicable to Windows installer
		rm tests/TestNsisUtilities.py || die

		# these fail on upstream Travis CI as well as on Gentoo
		sed -e "s/test_notify(self)/_&/" \
			-i tests/TestGUI.py || die

		sed -e "s/test_get_proc_swaps(self)/_&/" \
			-i tests/TestMemory.py || die
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
