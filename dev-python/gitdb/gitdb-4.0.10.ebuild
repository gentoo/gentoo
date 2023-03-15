# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="GitDB is a pure-Python git object database"
HOMEPAGE="
	https://github.com/gitpython-developers/gitdb/
	https://pypi.org/project/gitdb/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/smmap-3.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-vcs/git
	)
"

distutils_enable_tests pytest

src_test() {
	local i

	mkdir "${T}"/repo || die
	cd "${T}"/repo || die

	for (( i = 0; i < 2500; ++i )); do
		echo "${i}" > file"${i}" || die
	done

	git init || die
	git config user.email "you@example.com" || die
	git config user.name "Your Name" || die
	git add -A || die
	git commit -q -m ".." || die
	git clone --bare "${T}"/repo "${T}"/repo.git || die
	cd "${S}" || die

	distutils-r1_src_test
}

python_test() {
	local EPYTEST_IGNORE=(
		gitdb/test/performance
	)
	local -x GITDB_TEST_GIT_REPO_BASE="${T}"/repo.git
	epytest
}
