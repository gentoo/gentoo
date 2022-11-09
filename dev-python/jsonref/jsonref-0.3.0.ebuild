# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="An implementation of JSON Reference for Python"
HOMEPAGE="
	https://github.com/gazpachoking/jsonref/
	https://pypi.org/project/jsonref/
"
SRC_URI="
	https://github.com/gazpachoking/jsonref/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

python_test() {
	epytest tests.py
}
