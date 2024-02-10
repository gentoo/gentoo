# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Jinja2 Extension for Dates and Times"
HOMEPAGE="
	https://github.com/hackebrot/jinja2-time/
	https://pypi.org/project/jinja2-time/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-arrow-compat.patch
)

distutils_enable_tests pytest
