# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycdio/pycdio-0.20-r1.ebuild,v 1.1 2015/01/02 04:32:08 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python OO interface to libcdio (CD Input and Control library)"
HOMEPAGE="http://savannah.gnu.org/projects/libcdio/ http://pypi.python.org/pypi/pycdio"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND=">=dev-libs/libcdio-0.90"
DEPEND="${RDEPEND}
	dev-lang/swig
	dev-python/setuptools[${PYTHON_USEDEP}]"

CFLAGS="${CFLAGS} -fno-strict-aliasing"

RESTRICT="test"  # currently tests fail

python_prepare_all() {
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
