# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Backport of the concurrent.futures package from Python 3.2"
HOMEPAGE="https://pypi.python.org/pypi/futures"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" test_futures.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES )
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
