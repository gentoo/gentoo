# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_11 )

inherit distutils-r1 virtualx

DESCRIPTION="A graphical tool for browsing / editing files in both PyTables and HDF5 formats"
HOMEPAGE="https://vitables.org/"
SRC_URI="https://github.com/uvemas/ViTables/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/ViTables-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/qtpy[gui,${PYTHON_USEDEP}]
		dev-python/tables[${PYTHON_USEDEP}]
	')"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# upstream doesn't run testsuite
	tests/test_start.py::TestStart::test_l10n
)

python_test() {
	virtx epytest
}

python_install_all() {
	insinto /usr/share/${PN}
	doins -r vitables/icons
	dodoc -r doc/*
	distutils-r1_python_install_all
}
