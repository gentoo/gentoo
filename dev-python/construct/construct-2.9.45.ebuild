# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A powerful declarative parser for binary data"
HOMEPAGE="http://construct.readthedocs.io/ https://pypi.org/project/construct/"
SRC_URI="https://github.com/construct/construct/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

DEPEND="test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	pytest -vv || die "Tests failed under ${EPYTHON}"
}

pkg_postinst() {
	ewarn "Version 2.9.x has significant API and implementation changes from"
	ewarn "previous 2.8.x releases. Please read the documentation at"
	ewarn "https://construct.readthedocs.io/en/latest/transition29.html"
	ewarn "for more info."
}
