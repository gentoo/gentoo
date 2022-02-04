# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="OpenID support for modern servers and consumers"
HOMEPAGE="https://github.com/necaris/python3-openid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/defusedxml[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( ${RDEPEND}
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/psycopg[${PYTHON_USEDEP}]
	)
"

DOCS=( NEWS.md README.md )

python_test() {
	"${EPYTHON}" -m unittest -v openid.test.test_suite || die "Tests failed with ${EPYTHON}"
}
