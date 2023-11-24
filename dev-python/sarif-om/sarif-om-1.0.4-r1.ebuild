# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Classes implementing the SARIF 2.1.0 object model"
HOMEPAGE="
	https://pypi.org/project/sarif-om/
	https://github.com/microsoft/sarif-python-om/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]"
