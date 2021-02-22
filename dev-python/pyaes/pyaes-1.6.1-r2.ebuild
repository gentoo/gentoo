# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Pure-Python Implementation of the AES block-cipher and common modes of operation"
HOMEPAGE="https://pypi.org/project/pyaes/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/pycryptodome[${PYTHON_USEDEP}] )"

python_test() {
	local t fail=
	for t in tests/test-*.py; do
		einfo "${t}"
		"${EPYTHON}" "${t}" || fail=1
	done
	[[ ${fail} ]] && die "Tests fail with ${EPYTHON}"
}
