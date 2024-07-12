# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/_}
# keep compat in sync with PyQt5 or else it confuses some revdeps
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="sip extension module for PyQt5"
# note that PyQt5-sip is currently not on github, but this is the
# homepage listed upstream as of the writing of this
HOMEPAGE="https://github.com/Python-SIP/sip/"

LICENSE="BSD-2"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
