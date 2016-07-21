# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="RPC protocol for Twisted"
HOMEPAGE="http://foolscap.lothar.com/trac https://pypi.python.org/pypi/foolscap"
SRC_URI="http://${PN}.lothar.com/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc +ssl test"

# setup.py stipulates >=twisted-core-2.5.0 but failures occur in testsuite under -15.x
RDEPEND="
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	dev-python/service_identity[${PYTHON_USEDEP}]
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

python_test() {
	trial ${PN} || die "Tests fail for ${EPYTHON}"
}

python_compile_all() {
	local i;
	if use doc; then
		pushd doc > /dev/null
		mkdir build || die
		for i in ./*.rst
		do
			rst2html.py $i > ./build/${i/rst/html} || die
		done
		popd > /dev/null
	fi
}

python_test() {
	trial ${PN} || die "Tests fail for ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/. )
	distutils-r1_python_install_all
}
