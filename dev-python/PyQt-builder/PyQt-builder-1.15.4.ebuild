# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="The PEP 517 compliant PyQt build system"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqt-builder/"

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/sip-6.7.1[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc --no-autodoc

python_prepare_all() {
	distutils-r1_python_prepare_all

	# don't install prebuilt DLLs
	sed -i "s:'dlls/\*/\*',::" setup.py || die
}
