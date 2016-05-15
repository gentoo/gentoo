# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Yet another boost.python based wrapper for GraphicsMagick"
HOMEPAGE="https://pypi.python.org/pypi/pgmagick/ https://bitbucket.org/hhatto/pgmagick/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="media-gfx/graphicsmagick[cxx]
	dev-libs/boost:=[python,${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		media-fonts/corefonts )"

python_test() {
	# The tests are written for py2 only, however there is only
	# one test, test_pgmagick_libinfo.py
	# Need to adjust the one test to py3 syntax
	if python_is_python3; then
		sed -e 's: libinfo.version:(libinfo.version):' \
			-e 's: libinfo.library:(libinfo.library):' \
			-i test/test_pgmagick_libinfo.py || die
	fi

	for test in test/test_*.py; do
		"${PYTHON}" $test || die "test $test failed under ${EPYTHON}"
	done
	# As long as the order of pythons are not agon changed, this will suffice
}
