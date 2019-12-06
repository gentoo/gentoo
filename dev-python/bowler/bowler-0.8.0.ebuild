# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

MY_PN="B${PN:1}"

DESCRIPTION="Safe code refactoring for modern Python"
HOMEPAGE="https://pybowler.io/ https://github.com/facebookincubator/Bowler"
SRC_URI="https://github.com/facebookincubator/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/fissix[${PYTHON_USEDEP}]
	dev-python/sh[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

distutils_enable_tests unittest
