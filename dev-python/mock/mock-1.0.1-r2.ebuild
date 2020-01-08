# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="A Python Mocking and Patching Library for Testing"
HOMEPAGE="http://www.voidspace.org.uk/python/mock/ https://pypi.org/project/mock/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc test"
RESTRICT="!test? ( test )"

# dev-python/unittest2 is not required with Python >=3.2.
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' python2_7 pypy)
	)"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-fix-python3.4.patch )

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( docs/*.txt )

	distutils-r1_python_install_all

	if use doc; then
		dohtml -r html/ -x html/objects.inv -x html/output.txt -x html/_sources
	fi
}
