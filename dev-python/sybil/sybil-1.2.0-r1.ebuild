# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Automated testing for the examples in your documentation"
HOMEPAGE="https://github.com/cjw296/sybil"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# nose is used to test nosetests integration
BDEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
