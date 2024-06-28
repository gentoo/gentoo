# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{10..11} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_1{2..3} )

inherit distutils-r1 pypi

DESCRIPTION="A pure-Python implementation of the HTTP/2 priority tree"
HOMEPAGE="
	https://python-hyper.org/projects/priority/en/latest/
	https://github.com/python-hyper/priority/
	https://pypi.org/project/priority/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

PATCHES=(
	"${FILESDIR}"/priority-1.3.0-test-timeout.patch
)

distutils_enable_tests pytest

python_test() {
	# https://github.com/python/cpython/issues/105042
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping tests on ${EPYTHON} (xfail)"
		return
	fi

	epytest
}
