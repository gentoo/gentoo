# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
# keep compat in sync with pyqt5 or else it confuses some revdeps
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="sip extension module for PyQt5"
HOMEPAGE="https://pypi.org/project/PyQt5-sip/"

LICENSE="BSD-2"
SLOT="0/$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv x86"
