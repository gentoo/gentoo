# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=meson-python
DISTUTILS_EXT=1
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1 pypi

DESCRIPTION="Cython interface to sci-mathematics/primecount"
HOMEPAGE="https://pypi.org/project/primecountpy/
	https://github.com/dimpase/primecountpy"
SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"

# LICENSE clarification in README.md
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND=">=sci-mathematics/primecount-8.0:=
	dev-python/cysignals[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-build/meson-1.5.2
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]"
