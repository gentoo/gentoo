# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Py3k port of sgmllib"
HOMEPAGE="
	https://pypi.org/project/sgmllib3k/
"
SRC_URI="
	mirror://pypi/${PN::1}/${PN}/${P}.tar.gz
	test? (
		https://dev.gentoo.org/~arthurzam/distfiles/dev-python/${PN}/test_sgmllib.py.gz
	)
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	"${EPYTHON}" "${WORKDIR}/test_sgmllib.py" -v ||
		die "Tests failed with ${EPYTHON}"
}
