# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Unicode to ASCII transliteration"
HOMEPAGE="
	https://github.com/anyascii/anyascii/
	https://pypi.org/project/anyascii/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 x86"

distutils_enable_tests pytest
