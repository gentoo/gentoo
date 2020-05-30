# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

MY_PN="WSGIProxy2"

DESCRIPTION="HTTP proxying tools for WSGI apps"
HOMEPAGE="https://pypi.org/project/WSGIProxy2/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~ppc ppc64 s390 sparc x86"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/webob[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/webtest-2.0.17[${PYTHON_USEDEP}]
		dev-python/socketpool[${PYTHON_USEDEP}]
	)"
# Testing also revealed the suite needs latest webtest

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/wsgiproxy2-0.4.6-tests.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests nose

python_prepare_all() {
	sed -i '/with-coverage/ d' setup.cfg || die

	distutils-r1_python_prepare_all
}
