# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/_}
# keep compat in sync with PyQt6 or else it confuses some revdeps
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="sip module support for PyQt6"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/"

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv"
