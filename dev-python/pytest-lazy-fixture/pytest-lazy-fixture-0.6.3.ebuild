# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="It helps to use fixtures in pytest.mark.parametrize"
HOMEPAGE="https://github.com/tvorog/pytest-lazy-fixture"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/tox[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
