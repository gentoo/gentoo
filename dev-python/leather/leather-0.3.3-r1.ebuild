# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Python charting for 80% of humans."
HOMEPAGE="https://github.com/wireservice/leather https://pypi.org/project/leather/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? ( https://github.com/wireservice/leather/archive/refs/tags/${PV}.tar.gz -> ${P}-src.tar.gz ) "
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +xml"
RESTRICT="!test? ( test )"

# Other packages have BDEPEND="test? ( dev-python/leather[xml] )"
TEST_AGAINST_RDEPEND="xml? ( dev-python/lxml[${PYTHON_USEDEP}] )"
RDEPEND="
	${TEST_AGAINST_RDEPEND}
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
