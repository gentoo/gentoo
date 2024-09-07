# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit python-r1

DESCRIPTION="Virtual to install 'test' package from stdlib"
HOMEPAGE="https://docs.python.org/3/library/test.html"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_impl_dep 'test-install(+)' pypy3)
	$(python_gen_cond_dep '
		|| (
			dev-python/python-tests:3.10
			<dev-lang/python-3.10.14_p3-r1:3.10
		)
	' python3_10)
	$(python_gen_cond_dep '
		|| (
			dev-python/python-tests:3.11
			<dev-lang/python-3.11.9_p2-r1:3.11
		)
	' python3_11)
	$(python_gen_cond_dep '
		|| (
			dev-python/python-tests:3.12
			<dev-lang/python-3.12.5_p1-r1:3.12
		)
	' python3_12)
	$(python_gen_cond_dep '
		|| (
			dev-python/python-tests:3.13
			<dev-lang/python-3.13.0_rc1_p3-r1:3.13
		)
	' python3_13)
"
