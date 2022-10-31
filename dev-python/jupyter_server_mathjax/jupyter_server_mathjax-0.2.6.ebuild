# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="MathJax resources as a Jupyter Server Extension"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_server_mathjax/
	https://pypi.org/project/jupyter-server-mathjax/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/jupyter_server-1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/jupyter_packaging[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Don't try (and fail) to fetch things from the internet with npm
	# https://bugs.gentoo.org/820317
	sed -i -e '/cmdclass=cmdclass/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
