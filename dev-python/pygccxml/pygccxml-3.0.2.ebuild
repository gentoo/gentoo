# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A specialized XML reader to navigate C++ declarations"
HOMEPAGE="
	https://github.com/CastXML/pygccxml/
	https://pypi.org/project/pygccxml/
"
SRC_URI="
	https://github.com/CastXML/pygccxml/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv ~x86"

DEPEND="
	${PYTHON_DEPS}
	dev-libs/castxml
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

EPYTEST_DESELECT=(
	tests/test_smart_pointer.py
)

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-2.4.0-doc.patch"
	)

	distutils-r1_python_prepare_all
}
