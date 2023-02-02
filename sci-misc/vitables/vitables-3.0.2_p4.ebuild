# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

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
		dev-python/pytables[${PYTHON_USEDEP}]
		dev-python/QtPy[gui,${PYTHON_USEDEP}]
	')"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_prepare() {
	eapply ../debian/patches
	sed -e '/QtTest/d' -i tests/test_samples.py || die
	default
}

python_test() {
	virtx epytest
}
