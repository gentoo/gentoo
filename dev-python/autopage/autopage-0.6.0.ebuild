# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="A library to provide automatic paging for console output"
HOMEPAGE="
	https://github.com/zaneb/autopage/
	https://pypi.org/project/autopage/
"
SRC_URI="
	https://github.com/zaneb/autopage/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	sed -e 's/test_short_streaming_output/_&/' \
		-e 's/test_interrupt_early/_&/' \
		-i autopage/tests/test_end_to_end.py || die

	distutils-r1_src_prepare
}

python_test() {
	unset LESS PAGER
	eunittest
}
