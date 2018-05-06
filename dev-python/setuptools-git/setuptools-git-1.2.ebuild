# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Setuptools revision control system plugin for Git"
HOMEPAGE="https://github.com/wichert/setuptools-git"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		 dev-vcs/git"
RDEPEND="${DEPEND}"

python_test() {
	git config --global user.name "test user" || die
	git config --global user.email "test@email.com" || die
	esetup.py test
	retr=$?
}
