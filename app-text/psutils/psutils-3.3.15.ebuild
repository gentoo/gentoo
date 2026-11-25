# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Utilities for manipulating PostScript documents"
HOMEPAGE="
	https://github.com/rrthomas/psutils/
	https://pypi.org/project/psutils/
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

DEPEND="app-text/libpaper"
RDEPEND="
	${DEPEND}
	>=dev-python/puremagic-1.26[${PYTHON_USEDEP}]
	>=dev-python/pypdf-4.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	dev-python/argparse-manpage[${PYTHON_USEDEP}]
	test? (
		app-text/ghostscript-gpl
		dev-python/wand[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-datafiles )
distutils_enable_tests pytest

src_test() {
	# set C.UTF-8 to ensure papersize is A4 for pstops
	# see https://github.com/rrthomas/psutils/issues/91
	export LC_ALL=C.UTF-8
	distutils-r1_src_test
}
