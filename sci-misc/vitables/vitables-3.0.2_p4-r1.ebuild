# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 virtualx

DESCRIPTION="A graphical tool for browsing / editing files in both PyTables and HDF5 formats"
HOMEPAGE="https://vitables.org/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_$(ver_cut 1-3).orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_$(ver_cut 1-3)-$(ver_cut 5).debian.tar.xz"
S="${WORKDIR}/ViTables-$(ver_cut 1-3)"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/numexpr[${PYTHON_USEDEP}]
		dev-python/QtPy[gui,${PYTHON_USEDEP}]
		dev-python/tables[${PYTHON_USEDEP}]
	')"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	PATCHES=(
		../debian/patches/0001-vtsite.py-use-debian-doc-and-icons-paths.patch
		../debian/patches/0002-setup.py-no-icons-htmldocs-or-license.patch
		../debian/patches/0004-tests-conftest.py-prepare-the-testfile-if-necessary.patch
		../debian/patches/0005-Update-collection-path-for-Python-3.8.patch
		../debian/patches/0006-Fix-version-information-display.patch
		../debian/patches/0007-tests-migrate-from-nose-to-pytest.patch
	)

	distutils-r1_python_prepare_all
	sed -e '/QtTest/d' -i tests/test_samples.py || die
}

python_install_all() {
	insinto /usr/share/${PN}
	doins -r vitables/icons
	dodoc -r doc/*
	distutils-r1_python_install_all
}

python_test() {
	virtx epytest
}
