# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

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
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="+native-extensions test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=dev-libs/thrift-0.24.0
	)
"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# upstream tries True, and if it fails, tries False
	# just subtitute both to get what we want
	local build_ext=$(usex native-extensions True False)
	sed -e "/with_binary=/s:False\|True:${build_ext}:" \
		-i setup.py || die
}

python_test() {
	# upstream generates more files, but only this one seems to affect
	# test results
	thrift --gen py ../../test/Recursive.thrift || die

	eunittest test
}

src_install() {
	distutils-r1_src_install
	# avoid file collision with dev-libs/thrift (bug #933272)
	mv "${D}"/usr/share/doc/${P}/README.md \
		"${D}"/usr/share/doc/${P}/ReadMe.md || die
}
