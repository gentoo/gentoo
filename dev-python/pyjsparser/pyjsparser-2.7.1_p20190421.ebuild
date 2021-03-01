# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_COMMIT="5465d037b30e334cb0997f2315ec1e451b8ad4c1"

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Fast javascript parser based on esprima.js"
HOMEPAGE="
	https://github.com/PiotrDabkowski/pyjsparser/
	https://pypi.org/project/pyjsparser/
"
SRC_URI="https://github.com/PiotrDabkowski/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

RESTRICT="!test? ( test )"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="
	test? (
		dev-python/js2py
		dev-python/pytest
	)
"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

python_test() {
	"${EPYTHON}" ./test_runner.py || die "tests failed with ${EPYTHON}"
}
