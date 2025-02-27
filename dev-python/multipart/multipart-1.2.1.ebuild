# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} python3_13t )

inherit distutils-r1 pypi

DESCRIPTION="Parser for multipart/form-data"
HOMEPAGE="
	https://github.com/defnull/multipart/
	https://pypi.org/project/multipart/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

distutils_enable_tests pytest
