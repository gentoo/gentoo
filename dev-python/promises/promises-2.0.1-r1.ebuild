# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_P=${PN%s}-${PV}

DESCRIPTION="An implementation of Promises in Python"
HOMEPAGE="https://github.com/syrusakbary/promise"
SRC_URI="https://github.com/syrusakbary/${PN%s}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/python-typing[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

RESTRICT=test
# TODO: When we get all the dependencies in, we can add test
#	test? (
#		>=dev-python/pytest-2.7.3[${PYTHON_USEDEP}]
#		dev-python/pytest-cov[${PYTHON_USEDEP}]
#		dev-python/coveralls[${PYTHON_USEDEP}]
#		dev-python/futures[${PYTHON_USEDEP}]
#		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
#		dev-python/mock[${PYTHON_USEDEP}]
#	)

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
