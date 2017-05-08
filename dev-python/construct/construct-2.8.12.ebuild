# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A powerful declarative parser for binary data"
HOMEPAGE="http://construct.readthedocs.io/ https://pypi.python.org/pypi/construct"
SRC_URI="https://github.com/construct/construct/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test -vv || die "Tests failed under ${EPYTHON}"
}

pkg_postinst() {
	ewarn "Version 2.8.x has significant API and implementation changes from"
	ewarn "previous 2.5.x releases. Please read the documentation at"
	ewarn "http://construct.readthedocs.io/ for more info."
}
