# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

MY_PN=${PN#python-}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Function decoration for backoff and retry"
HOMEPAGE="https://github.com/litl/backoff https://pypi.org/project/backoff/"
SRC_URI="https://github.com/litl/backoff/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( README.rst )

BDEPEND="test? ( dev-python/pytest-asyncio[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
