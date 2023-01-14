# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python tool configuration"
HOMEPAGE="
	https://pypi.org/project/pytoolconfig/
	https://github.com/bagel897/pytoolconfig/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{8..10} )
"
BDEPEND="
	>=dev-python/pdm-pep517-1.0.5[${PYTHON_USEDEP}]
	test? (
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/tabulate-0.8.9[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# remove overstrict dep
	sed -i -e '/packaging/s:>=22.0::' pyproject.toml || die
	distutils-r1_src_prepare
}
