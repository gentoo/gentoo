# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Configuration manager in your pocket"
HOMEPAGE="https://github.com/emre/kaptan"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="kaptan"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}
	>=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
