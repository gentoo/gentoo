# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Easy VCS-based management of project version strings"
HOMEPAGE="https://pypi.org/project/versioneer/ https://github.com/warner/python-versioneer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py make_versioneer
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"

	${PYTHON} test/git/test_git.py -v || die
}
