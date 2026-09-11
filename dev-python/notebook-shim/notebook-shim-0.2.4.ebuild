# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=(  python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="A shim layer for notebook traits and config"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/notebook_shim/
	https://pypi.org/project/notebook-shim/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	<dev-python/jupyter-server-3[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-1.8[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-{jupyter,tornasync} )
distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
