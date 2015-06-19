# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/numpydoc/numpydoc-0.4-r1.ebuild,v 1.7 2015/02/16 13:45:37 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Sphinx extension to support docstrings in Numpy format"
HOMEPAGE="https://pypi.python.org/pypi/numpydoc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	chmod -R a+r *.egg-info || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Tests are written only for py2m pypy
	if ! python_is_python3; then
		nosetests || die "Testing failed with ${EPYTHON}"
	fi
}
