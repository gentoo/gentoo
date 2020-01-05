# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="A utility belt for advanced users of python-requests"
HOMEPAGE="https://toolbelt.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="test"

RDEPEND="<dev-python/requests-3.0.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/betamax[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst HISTORY.rst README.rst )
PATCHES=(
	"${FILESDIR}/requests-toolbelt-0.8.0-test-tracebacks.patch"
)

# Known python2.7 test failures do to upstream
# not testing with newer requests versions
# bug: https://bugs.gentoo.org/635824
# https://github.com/requests/toolbelt/issues/213
RESTRICT=test

python_test() {
	py.test -v || die "Tests failed with ${EPYTHON}"
}
