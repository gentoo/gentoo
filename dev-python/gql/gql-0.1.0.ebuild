# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="GraphQL client for Python."
HOMEPAGE="https://pypi.org/project/gql/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/graphql-core-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/promises-2.1[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-2.7.2[${PYTHON_USEDEP}]
	)
"
