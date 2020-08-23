# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Core common functionality of Jupyter projects"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="dev-python/traitlets[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		>=dev-python/ipython-4.0.1[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs \
	dev-python/sphinxcontrib-github-alt
distutils_enable_tests pytest

python_prepare_all() {
	# rely on imports working without PYTHONPATH
	sed -e 's:test_not_on_path:_&:' \
		-e 's:test_path_priority:_&:' \
		-i jupyter_core/tests/test_command.py || die

	distutils-r1_python_prepare_all
}
