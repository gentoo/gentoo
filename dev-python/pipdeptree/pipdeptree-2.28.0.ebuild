# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 pypi optfeature

DESCRIPTION="Utility for displaying installed packages in a dependency tree"
HOMEPAGE="
	https://github.com/tox-dev/pipdeptree/
	https://pypi.org/project/pipdeptree/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
	>=dev-python/pip-23.1.2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/graphviz[${PYTHON_USEDEP}]
		<dev-python/virtualenv-21[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20.31.1[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{mock,rerunfailures} )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# upstream lower bounds are meaningless
	sed -i -e 's:>=[0-9.]*,\?::' pyproject.toml || die

	find -name '*.py' -exec \
		sed -i -e 's:pip[.]_vendor[.]::' {} + || die
}

python_test() {
	# tests can fail if other packages are being merged simultaneously
	epytest --reruns=5
}

pkg_postinst() {
	optfeature \
		"visualising the dependency graph with --graph-output" \
		dev-python/graphviz
}
