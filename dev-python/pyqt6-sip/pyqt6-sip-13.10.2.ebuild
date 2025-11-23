# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
# keep compat in sync with pyqt6 or else it confuses some revdeps
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="sip module support for PyQt6"
HOMEPAGE="https://pypi.org/project/PyQt6-sip/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv x86"
