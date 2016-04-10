# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3  )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Distribution utilities"
HOMEPAGE="https://pypi.python.org/pypi/distlib https://bitbucket.org/vinay.sajip/distlib https://github.com/vsajip/distlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-unbundle.patch
	"${FILESDIR}"/${P}-online.patch
)

python_prepare_all() {
	rm -r \
		distlib/*.exe \
		distlib/_backport \
		tests/test_shutil.py* \
		tests/test_sysconfig.py* || die

	distutils-r1_python_prepare_all

	# Broken tests
	# 1 fails due to it being sensitive to dictionary ordering
	# inconsistency between code and test
	sed \
		-e 's:test_dependency_finder:_&:g' \
		-i tests/*py || die

	# Gentoo still doesn't report correct ABI
	sed \
		-e 's:test_abi:_&:g' \
		-i tests/*py || die
}

python_test() {
	sed \
		-e '/PIP_AVAILABLE/s:True:False:g' \
		-i tests/*py || die
	SKIP_ONLINE=True PYTHONHASHSEED=0 esetup.py test
}
