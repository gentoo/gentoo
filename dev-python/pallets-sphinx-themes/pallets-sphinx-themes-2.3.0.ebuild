# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=Pallets-Sphinx-Themes
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx themes for Pallets and related projects"
HOMEPAGE="
	https://github.com/pallets/pallets-sphinx-themes/
	https://pypi.org/project/Pallets-Sphinx-Themes/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/sphinx-3[${PYTHON_USEDEP}]
	dev-python/sphinx-notfound-page[${PYTHON_USEDEP}]
"
