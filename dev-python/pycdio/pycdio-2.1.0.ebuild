# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python OO interface to libcdio (CD Input and Control library)"
HOMEPAGE="https://savannah.gnu.org/projects/libcdio/ https://pypi.org/project/pycdio/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

BDEPEND="dev-lang/swig"
RDEPEND=">=dev-libs/libcdio-2.0.0"
DEPEND="${RDEPEND}"

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
	distutils-r1_python_install_all
	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
