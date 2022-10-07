# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="C-style structs for Python"
HOMEPAGE="https://github.com/andreax79/python-cstruct
	https://pypi.org/project/cstruct/"
SRC_URI="
	https://github.com/andreax79/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	sed -e "/find_packages(/s@exclude=\[@&'tests', @" -i setup.py || die
}
