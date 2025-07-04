# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A python port of YUI CSS Compressor"
HOMEPAGE="
	https://github.com/sprymix/csscompressor
	https://pypi.org/project/csscompressor/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

distutils_enable_tests pytest
