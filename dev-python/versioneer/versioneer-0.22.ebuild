# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Easy VCS-based management of project version strings"
HOMEPAGE="
	https://pypi.org/project/versioneer/
	https://github.com/python-versioneer/python-versioneer/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

python_test() {
	esetup.py make_versioneer

	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die

	"${EPYTHON}" test/git/test_git.py -v || die
}
