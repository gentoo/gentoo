# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="GitDB is a pure-Python git object database"
HOMEPAGE="
	https://github.com/gitpython-developers/gitdb
	https://pypi.org/project/gitdb2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-python/gitdb[${PYTHON_USEDEP}]
	>=dev-python/smmap2-2.0.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-vcs/git
	)"

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
	#TRAVIS=1 disables performance tests which rely on the gitdb repo
	local -x TRAVIS=1
	local -x GITDB_TEST_GIT_REPO_BASE="${T}"/repo.git
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
