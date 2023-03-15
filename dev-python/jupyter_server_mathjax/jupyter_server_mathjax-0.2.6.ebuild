# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="MathJax resources as a Jupyter Server Extension"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_server_mathjax/
	https://pypi.org/project/jupyter-server-mathjax/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/jupyter_server-1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/jupyter_packaging[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/pytest_jupyter[${PYTHON_USEDEP}]
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
