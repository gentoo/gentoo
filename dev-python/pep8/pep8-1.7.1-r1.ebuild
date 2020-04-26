# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Python style guide checker"
HOMEPAGE="https://github.com/PyCQA/pep8 https://pypi.org/project/pep8/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.1-fix_tests.patch
)

python_test() {
	PYTHONPATH="${S}" "${EPYTHON}" pep8.py -v --statistics pep8.py || die "Tests failed with ${EPYTHON}"
	PYTHONPATH="${S}" "${EPYTHON}" pep8.py -v --testsuite=testsuite || die "Tests failed with ${EPYTHON}"
	PYTHONPATH="${S}" "${EPYTHON}" pep8.py --doctest -v || die "Tests failed with ${EPYTHON}"
	esetup.py test || die "Tests failed with ${EPYTHON}"
}

distutils_enable_sphinx docs
