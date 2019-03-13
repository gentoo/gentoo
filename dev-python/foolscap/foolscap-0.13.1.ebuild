# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="RPC protocol for Twisted"
HOMEPAGE="http://foolscap.lothar.com/trac https://pypi.org/project/foolscap/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc +ssl test"

# Many tests still failing (#657604), others rely on network
RESTRICT="test"

RDEPEND="
	>=dev-python/twisted-16[${PYTHON_USEDEP}]
	dev-python/service_identity[${PYTHON_USEDEP}]
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"
#dev-python/txtorcon[${PYTHON_USEDEP}] will be needed when tests work

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
