# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="Parse strings using a specification based on the Python format() syntax"
HOMEPAGE="https://github.com/r1chardj0n3s/parse/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

distutils_enable_tests pytest
