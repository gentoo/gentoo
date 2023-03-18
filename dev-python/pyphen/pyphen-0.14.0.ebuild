# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python module for hyphenation using hunspell dictionaries"
HOMEPAGE="
	https://github.com/Kozea/Pyphen/
	https://pypi.org/project/pyphen/
"

LICENSE="GPL-2+ LGPL-2+ MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
