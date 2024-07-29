# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Curses-like terminal wrapper, with colored strings"
HOMEPAGE="
	https://github.com/bpython/curtsies/
	https://pypi.org/project/curtsies/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/blessed-1.5[${PYTHON_USEDEP}]
	dev-python/cwcwidth[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pyte[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
