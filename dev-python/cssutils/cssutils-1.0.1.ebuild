# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library"
HOMEPAGE="https://pypi.python.org/pypi/cssutils/ https://bitbucket.org/cthedot/cssutils http://cthedot.de/cssutils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${P}-pypy-test-backport.patch
)

python_prepare_all() {
	# Disable test failing with dev-python/pyxml installed.
	if has_version dev-python/pyxml; then
		sed -e "s/test_linecol/_&/" -i src/tests/test_errorhandler.py
	fi

	# requires old pbr, does it really?
	sed \
		-e '/tests_require/d' \
		-i setup.py || die

	EPATCH_OPTS="--binary"

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
