# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Type Hints for Python"
HOMEPAGE="https://docs.python.org/3.5/library/typing.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

python_test() {
	cd "${BUILD_DIR}" || die
	if [[ ${EPYTHON} == python2* || ${EPYTHON} == pypy ]]; then
		cp "${S}"/python2/test_typing.py . || die
	else
		cp "${S}"/src/test_typing.py . || die
	fi

	"${EPYTHON}" test_typing.py || die "tests failed under ${EPYTHON}"
}
