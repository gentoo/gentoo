# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="IPython HTML widgets for Jupyter"
HOMEPAGE="
	https://ipython.org/
	https://pypi.org/project/widgetsnbextension/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/notebook[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install

	mv "${ED}/usr/etc" "${ED}/etc" || die
}
