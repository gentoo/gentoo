# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Module for click to enable registering CLI commands via setuptools entry-points"
HOMEPAGE="https://github.com/click-contrib/click-plugins"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
SLOT="0"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]"
BDEPEND="test? ( ${RDEPEND} )"

distutils_enable_tests pytest
