# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

MY_P="${PN}.six-${PV}"
DESCRIPTION="Python tool for extracting information from PDF documents"
HOMEPAGE="https://pdfminersix.readthedocs.io/en/latest/"
# Release tarballs lack tests
#SRC_URI="https://github.com/pdfminer/pdfminer.six/releases/download/${PV}/${MY_P}.tar.gz"
SRC_URI="https://github.com/pdfminer/pdfminer.six/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=">=dev-python/charset_normalizer-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-36.0.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e "s:package.__version__:${PV}:" setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use examples && emake -C samples all
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	use examples && dodoc -r samples
	distutils-r1_python_install_all
}
