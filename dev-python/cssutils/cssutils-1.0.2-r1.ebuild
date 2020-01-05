# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library"
HOMEPAGE="https://pypi.org/project/cssutils/ https://bitbucket.org/cthedot/cssutils http://cthedot.de/cssutils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Disable test failing with dev-python/pyxml installed.
	if has_version dev-python/pyxml; then
		sed -e "s/test_linecol/_&/" \
			-i src/cssutils/tests/test_errorhandler.py \
			|| die
	fi

	# requires old pbr, does it really?
	sed \
		-e '/tests_require/d' \
		-i setup.py || die

	# fix casing of call to Windows-1252. Remove when upstream fixes casing.
	sed -i -e 's/encutils.tryEncodings(test)/encutils.tryEncodings(test).lower()/' \
	src/cssutils/tests/test_encutils/__init__.py || die "fixing test_encutils failed"

	distutils-r1_python_prepare_all
}

python_test() {
	ln -s "${S}/sheets" "${BUILD_DIR}/sheets" || die
	# esetup.py test
	# exclude tests that connect to the network
	set --  nosetests \
		-e test_parseUrl -e test_handlers -P "${BUILD_DIR}/lib/cssutils/tests"
	echo "$@"
	"$@" || die "Testing failed with ${EPYTHON}"
}
