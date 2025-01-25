# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Tool and library for manipulating LilyPond files"
HOMEPAGE="
	https://github.com/frescobaldi/python-ly/
	https://pypi.org/project/python-ly/
"
SRC_URI="
	https://github.com/frescobaldi/python-ly/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
# https://github.com/frescobaldi/python-ly/issues/176
SRC_URI+="
	test? (
		https://www.w3.org/2001/03/xml.xsd
		https://www.w3.org/XML/2008/06/xlink.xsd
	)
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	# https://github.com/frescobaldi/python-ly/issues/176
	sed -e 's:\(schemaLocation="\).*/\([a-z]*\.xsd"\):\1\2:' \
		-i tests/musicxml.xsd || die
	cp "${DISTDIR}"/{xml,xlink}.xsd tests/ || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	distutils-r1_src_test
}
