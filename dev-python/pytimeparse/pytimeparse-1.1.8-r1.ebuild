# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A small Python module to parse various kinds of time expressions"
HOMEPAGE="
	https://github.com/wroberts/pytimeparse/
	https://pypi.org/project/pytimeparse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~arm64-macos ~x64-macos"

distutils_enable_tests unittest
