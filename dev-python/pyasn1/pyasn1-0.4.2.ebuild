# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="ASN.1 library for Python"
HOMEPAGE="http://snmplabs.com/pyasn1/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test || die "Tests fail with ${EPYTHON}"
}

src_compile() {
	if use doc; then
		python_setup
		esetup.py build_sphinx
	fi
	distutils-r1_src_compile
}

src_install() {
	local HTML_DOCS
	use doc && HTML_DOCS=( build/sphinx/html/. )

	distutils-r1_src_install
}
