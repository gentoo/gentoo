# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="The PEP 517 compliant PyQt build system"
HOMEPAGE="https://github.com/Python-PyQt/PyQt-builder/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/sip-6.7[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

src_prepare() {
	distutils-r1_src_prepare

	# don't install prebuilt DLLs
	rm -r pyqtbuild/bundle/dlls || die
}
