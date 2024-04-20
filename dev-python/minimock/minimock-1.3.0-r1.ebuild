# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P="MiniMock-${PV}"
DESCRIPTION="The simplest possible mock library"
HOMEPAGE="
	https://github.com/lowks/minimock/
	https://pypi.org/project/MiniMock/
"
SRC_URI="
	https://github.com/lowks/minimock/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"

DOCS=( CHANGELOG.txt README.rst )

distutils_enable_tests pytest

python_test() {
	epytest --doctest-modules
}
