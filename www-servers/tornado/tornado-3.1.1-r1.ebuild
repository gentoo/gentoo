# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python web framework and asynchronous networking library"
HOMEPAGE="http://www.tornadoweb.org/ https://pypi.python.org/pypi/tornado"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="curl test"

RDEPEND="curl? ( dev-python/pycurl[$(python_gen_usedep python2_7)] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		python_targets_python2_7? ( dev-python/twisted-names[python_targets_python2_7] )
	)
"

REQUIRED_USE="curl? ( || ( $(python_gen_useflags python2_7) ) )"

PATCHES=(
	"${FILESDIR}/unittest2-import-issue-1005.patch"
	"${FILESDIR}/${P}-py2_6-tests-fix.patch"
)

python_test() {
	cd "${TMPDIR}" || die
	"${PYTHON}" -m tornado.test.runtests || die "Tests fail with ${EPYTHON}"
}
