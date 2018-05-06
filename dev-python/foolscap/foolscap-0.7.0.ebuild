# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="RPC protocol for Twisted"
HOMEPAGE="http://foolscap.lothar.com/trac https://pypi.org/project/foolscap"
SRC_URI="http://${PN}.lothar.com/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc +ssl test"

RDEPEND=">=dev-python/twisted-core-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-web-2.5.0[${PYTHON_USEDEP}]
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

python_test() {
	trial ${PN} || die "Tests fail for ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		dodoc doc/*.txt
		dohtml -A py,tpl,xhtml -r doc/*
	fi
}
