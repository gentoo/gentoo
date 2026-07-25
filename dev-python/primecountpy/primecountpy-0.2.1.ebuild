# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYPI_PN=${PN^}
PYPI_VERIFY_REPO=https://github.com/dimpase/primecountpy
PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Cython interface to sci-mathematics/primecount"
HOMEPAGE="
	https://github.com/dimpase/primecountpy/
	https://pypi.org/project/primecountpy/
"

# LICENSE clarification in README.md
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv"

DEPEND="
	>=sci-mathematics/primecount-8.0:=
	dev-python/cysignals[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-build/meson-1.5.2
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]
"
