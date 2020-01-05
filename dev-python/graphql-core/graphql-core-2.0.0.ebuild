# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="GraphQL for Python"
HOMEPAGE="https://github.com/graphql-python/graphql-core"
SRC_URI="https://github.com/graphql-python/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/promises-2.1[${PYTHON_USEDEP}]
	>=dev-python/Rx-1.6.0[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT="test"
# Add these to test when we have them in the tree
#	test? (
#		=dev-python/pytest-3.0.2
#		=dev-python/pytest-django-2.9.1
#		=dev-python/pytest-cov-2.3.1
#		dev-python/coveralls
#		=dev-python/gevent-1.1-rc1
#		=dev-python/pytest-benchmark-3.0.0
#		=dev-python/pytest-mock-1.2
#	)
