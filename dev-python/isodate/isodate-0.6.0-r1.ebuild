# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="ISO 8601 date/time/duration parser and formatter"
HOMEPAGE="https://pypi.org/project/isodate/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( ${RDEPEND} )"

python_test() {
	"${EPYTHON}" -m unittest discover -v -s "${BUILD_DIR}/lib" \
		|| die "Testing failed with ${EPYTHON}"
}
