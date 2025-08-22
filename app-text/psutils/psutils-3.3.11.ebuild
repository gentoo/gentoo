# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Utilities for manipulating PostScript documents"
HOMEPAGE="
	https://github.com/rrthomas/psutils/
	https://pypi.org/project/psutils/
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="app-text/libpaper"
RDEPEND="
	${DEPEND}
	>=dev-python/puremagic-1.26[${PYTHON_USEDEP}]
	>=dev-python/pypdf-4.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/argparse-manpage[${PYTHON_USEDEP}]
	test? ( dev-python/wand[${PYTHON_USEDEP}] )
"

EPYTEST_PLUGINS=( pytest-datafiles )
EPYTEST_DESELECT=(
	# fails on test env the first time only, get ipc-timeout
	# TODO: more investigations
	"tests/test_pstops.py::test_pstops[.ps-default-paper-size]"
	"tests/test_pstops.py::test_pstops[.ps-man-page-example]"
	# requires ghostscript-gpl
	# wand.exceptions.DelegateError: FailedToExecuteCommand `'gs' [...]
	"tests/test_pstops.py::test_pstops[.pdf-default-paper-size]"
	"tests/test_pstops.py::test_pstops[.pdf-man-page-example]"
)

distutils_enable_tests pytest
