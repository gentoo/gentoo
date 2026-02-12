# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Signature generator for Python programs"
HOMEPAGE="
	https://mkdocstrings.github.io/griffe/
	https://github.com/mkdocstrings/griffe/
	https://pypi.org/project/griffe/
"
# Tests need files absent from the PyPI tarballs
SRC_URI="
	https://github.com/mkdocstrings/griffe/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# pdm-backend used via hatchling hooks
BDEPEND="
	dev-python/pdm-backend[${PYTHON_USEDEP}]
	dev-python/uv-dynamic-versioning[${PYTHON_USEDEP}]
	dev-vcs/git
	test? (
		>=dev-python/griffe-inherited-docstrings-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-4.17[${PYTHON_USEDEP}]
		>=dev-python/mkdocstrings-0.28.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-gitconfig )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fragile to installed packages
	# (failed on PySide2 for me)
	tests/test_stdlib.py::test_fuzzing_on_stdlib
)

src_compile() {
	# The build system combines hatchling with git hooks from pdm-backend
	# and uv-dynamic-versioning.  It does not respect PDM_BUILD_SCM_VERSION,
	# and uv-dynamic-versioning does not work without a git repository
	# at all, even though it does not use it for anything.
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die
	git init || die
	git commit --allow-empty -m "force version" || die
	git tag "${PV}" || die

	distutils-r1_src_compile
}

python_compile() {
	# This packages is a horrendous mess.  It's split into three packages,
	# and tests require all of them.
	local pkg
	for pkg in packages/griffe{lib,cli} .; do
		pushd "${pkg}" >/dev/null || die
		distutils-r1_python_compile
		popd >/dev/null || die
	done
}
