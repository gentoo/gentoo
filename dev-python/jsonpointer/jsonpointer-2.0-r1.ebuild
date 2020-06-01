# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

DESCRIPTION="Identify specific nodes in a JSON document (according to draft 08)"
HOMEPAGE="https://github.com/stefankoegl/python-json-pointer https://pypi.org/project/jsonpointer/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" tests.py || die "Tests fail with ${EPYTHON}"
}
