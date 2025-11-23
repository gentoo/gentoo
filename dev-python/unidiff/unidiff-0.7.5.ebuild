# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Unified diff parsing/metadata extraction library"
HOMEPAGE="
	https://github.com/matiasb/python-unidiff/
	https://pypi.org/project/unidiff/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"

distutils_enable_tests pytest
