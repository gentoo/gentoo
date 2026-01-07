# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python implementation of Thrift"
HOMEPAGE="
	https://pypi.org/project/thrift/
	https://thrift.apache.org/
	https://github.com/apache/thrift
"
SRC_URI="
	mirror://apache/${PN}/${PV}/${P}.tar.gz
"
S="${WORKDIR}/${P}/lib/py"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

distutils_enable_tests unittest

python_test() {
	eunittest test
}

src_install() {
	distutils-r1_src_install
	# avoid file collision with dev-libs/thrift (bug #933272)
	mv "${D}"/usr/share/doc/${P}/README.md \
		"${D}"/usr/share/doc/${P}/ReadMe.md || die
}
