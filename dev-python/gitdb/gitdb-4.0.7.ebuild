# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="GitDB is a pure-Python git object database"
HOMEPAGE="
	https://github.com/gitpython-developers/gitdb
	https://pypi.org/project/gitdb/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	>=dev-python/smmap-3.0.1[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-vcs/git
	)"

distutils_enable_tests nose

src_prepare() {
	# remove unnecessary version restriction
	# https://github.com/gitpython-developers/gitdb/issues/67
	sed -i -e '/smmap/s:,<4::' setup.py || die
	distutils-r1_src_prepare
}

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
