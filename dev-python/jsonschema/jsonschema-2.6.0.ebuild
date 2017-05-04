# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="An implementation of JSON-Schema validation for Python"
HOMEPAGE="https://pypi.python.org/pypi/jsonschema https://github.com/Julian/jsonschema"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	dev-python/rfc3987[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/strict-rfc3339[${PYTHON_USEDEP}]
	dev-python/webcolors[${PYTHON_USEDEP}]
	$(python_gen_cond_dep \
		'dev-python/functools32[${PYTHON_USEDEP}]' 'python2*' pypy)
	"
DEPEND="${RDEPEND}
	>=dev-python/vcversioner-2.16.0.0[${PYTHON_USEDEP}]
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

python_test() {
	"${PYTHON}" -m unittest discover || die "Testing failed with ${EPYTHON}"
}
