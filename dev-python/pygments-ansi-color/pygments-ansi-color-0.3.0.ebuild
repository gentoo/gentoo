# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="ANSI color-code highlighting for Pygments"
HOMEPAGE="https://pypi.org/project/pygments-ansi-color/"
# No tests in PyPI tarballs
SRC_URI="https://github.com/chriskuehl/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
