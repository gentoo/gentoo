# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3  )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Distribution utilities"
HOMEPAGE="https://pypi.org/project/distlib https://bitbucket.org/vinay.sajip/distlib https://github.com/vsajip/distlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="app-arch/unzip"

python_test() {
	sed \
		-e '/PIP_AVAILABLE/s:True:False:g' \
		-i tests/*py || die
	PYTHONHASHSEED=0 esetup.py test
}
