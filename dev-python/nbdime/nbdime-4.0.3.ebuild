# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Diff and merge of Jupyter Notebooks"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/nbdime/
	https://pypi.org/project/nbdime/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/gitpython[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/jupyter-server[${PYTHON_USEDEP}]
	dev-python/jupyter-server-mathjax[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source \
	dev-python/recommonmark \
	dev-python/sphinx-rtd-theme
EPYTEST_PLUGINS=( pytest-timeout )
distutils_enable_tests pytest

src_test() {
	# user.email and user.name are not configured in the sandbox
	git config --global user.email "larry@gentoo.org" || die
	git config --global user.name "Larry the Cow" || die

	distutils-r1_src_test
}

python_test() {
	local EPYTEST_IGNORE=(
		# require pytest-tornado
		nbdime/tests/test_web.py
	)

	epytest -o tmp_path_retention_policy=all
}

src_install() {
	distutils-r1_src_install
	mv "${ED}"{/usr,}/etc || die
}
