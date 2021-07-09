# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="cChardet is high speed universal character encoding detector"
HOMEPAGE="https://pypi.org/project/cchardet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-i18n/uchardet
"
BDEPEND="
	test? (
		>=dev-python/chardet-3.4.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_test() {
	"${EPYTHON}" setup.py nosetests || die "Tests fail with ${EPYTHON}"
}
