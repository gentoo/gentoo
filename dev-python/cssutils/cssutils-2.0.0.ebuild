# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library"
HOMEPAGE="https://pypi.org/project/cssutils/ https://cthedot.de/cssutils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# fix casing of call to Windows-1252. Remove when upstream fixes casing.
	sed -i -e 's/encutils.tryEncodings(test)/encutils.tryEncodings(test).lower()/' \
		cssutils/tests/test_encutils/__init__.py ||
		die "fixing test_encutils failed"

	distutils-r1_python_prepare_all
}

python_test() {
	ln -s "${S}/sheets" "${BUILD_DIR}/sheets" || die
	# esetup.py test
	# exclude tests that connect to the network
	set -- nosetests -v -P "${BUILD_DIR}/lib/cssutils/tests" \
		-e test_parseUrl
	echo "$@"
	"$@" || die "Testing failed with ${EPYTHON}"
}
