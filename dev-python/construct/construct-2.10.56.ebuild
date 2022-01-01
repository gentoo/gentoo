# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A powerful declarative parser for binary data"
HOMEPAGE="https://construct.readthedocs.io/en/latest/ https://pypi.org/project/construct/"
SRC_URI="https://github.com/construct/construct/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests pytest
BDEPEND+="
	test? (
		dev-python/arrow[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.15.4[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	)"

src_prepare() {
	default
	rm tests/test_benchmarks.py || die
}

pkg_postinst() {
	ewarn "Version 2.10.x has significant API and implementation changes from"
	ewarn "previous 2.9.x releases. Please read the documentation at"
	ewarn "https://construct.readthedocs.io/en/latest/transition210.html"
	ewarn "for more info."
}
