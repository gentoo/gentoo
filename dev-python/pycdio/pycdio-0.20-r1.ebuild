# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python OO interface to libcdio (CD Input and Control library)"
HOMEPAGE="https://savannah.gnu.org/projects/libcdio/ https://pypi.python.org/pypi/pycdio"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND=">=dev-libs/libcdio-0.90"
DEPEND="${RDEPEND}
	dev-lang/swig
	dev-python/setuptools[${PYTHON_USEDEP}]"

RESTRICT="test"  # currently tests fail

python_prepare_all() {
	append-cflags -fno-strict-aliasing
	# Remove obsolete sys.path and adjust 'data' paths in examples.
	sed -i \
		-e "s:^sys.path.insert.*::" \
		-e "s:\.\./data:./data:g" \
		example/*.py || die

	# Disable failing tests.
	sed -i -e "s/test_get_set/_&/" test/test-cdtext.py || die
	sed -i -e "s/test_fs/_&/" test/test-isocopy.py || die
	distutils-r1_python_prepare_all
}

python_install_all(){
	use examples && local EXAMPLES=( example/. )
	distutils-r1_python_install_all
}
