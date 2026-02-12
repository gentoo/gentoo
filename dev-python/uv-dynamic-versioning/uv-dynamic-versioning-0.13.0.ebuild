# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/ninoseki/uv-dynamic-versioning
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Dynamic versioning based on VCS tags for uv/hatch project"
HOMEPAGE="
	https://github.com/ninoseki/uv-dynamic-versioning/
	https://pypi.org/project/uv-dynamic-versioning/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/dunamai-1.25[${PYTHON_USEDEP}]
	>=dev-python/hatchling-1.26[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.13[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/gitpython-3.1.45[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin dependencies
	sed -i -e 's:~=:>=:' pyproject.toml || die
}

src_test() {
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die

	git init || die
	git commit --allow-empty -m 'test suite needs a git repo' || die

	distutils-r1_src_test
}
