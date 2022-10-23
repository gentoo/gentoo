# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="ViTables"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A graphical tool for browsing / editing files in both PyTables and HDF5 formats"
HOMEPAGE="https://vitables.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

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
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			<dev-python/sip-5[${PYTHON_USEDEP}]
			dev-python/nose[${PYTHON_USEDEP}]
	')
	)
"

distutils_enable_tests pytest
