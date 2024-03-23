# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi optfeature

DESCRIPTION="Utility for displaying installed packages in a dependency tree"
HOMEPAGE="
	https://github.com/tox-dev/pipdeptree/
	https://pypi.org/project/pipdeptree/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/graphviz[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# https://github.com/tox-dev/pipdeptree/pull/302
	"${FILESDIR}/pipdeptree-2.13.1-expect-hpy-in-pypy-7.3.3.patch"
	"${FILESDIR}/pipdeptree-2.13.2-fix-pypy-7.3.14.patch"
)

distutils_enable_tests pytest

pkg_postinst() {
	optfeature \
		"visualising the dependency graph with --graph-output" \
		dev-python/graphviz
}
