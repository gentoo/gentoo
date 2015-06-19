# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/encore/encore-0.5.1.ebuild,v 1.5 2015/03/08 23:46:27 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Enthought Tool Suite: collection of core-level utility modules"
HOMEPAGE="https://github.com/enthought/encore"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="virtual/python-futures[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${P}-pypy-tests.patch )

python_test() {
	"${PYTHON}" -m unittest discover ./${PN}/events || die
	# PYTHONPATH goes astray & '-m unittest discover' loses its way. nose works
	# https://github.com/enthought/encore/issues/84
	# tests for storage simply aren't written to cater to pypy
	if [[ "${EPYTHON}" == python2.7 ]]; then
		nosetests ./${PN}/storage || die
	fi
}
