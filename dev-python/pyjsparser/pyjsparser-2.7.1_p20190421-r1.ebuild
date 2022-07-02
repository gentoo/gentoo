# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=5465d037b30e334cb0997f2315ec1e451b8ad4c1
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Fast javascript parser based on esprima.js"
HOMEPAGE="https://github.com/PiotrDabkowski/pyjsparser/
	https://pypi.org/project/pyjsparser/"
SRC_URI="https://github.com/PiotrDabkowski/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

RESTRICT="!test? ( test )"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86"
IUSE="test"

BDEPEND="
	test? (
		dev-python/js2py[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" ./test_runner.py || die "tests failed with ${EPYTHON}"
}
