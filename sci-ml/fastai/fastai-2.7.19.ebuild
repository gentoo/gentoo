# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 pypi

DESCRIPTION="The fastai deep learning library"
HOMEPAGE="https://www.fast.ai/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # No test available

RDEPEND="
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		sci-ml/fastcore[${PYTHON_USEDEP}]
		sci-ml/fastdownload[${PYTHON_USEDEP}]
		sci-ml/fastprogress[${PYTHON_USEDEP}]
	')
"
