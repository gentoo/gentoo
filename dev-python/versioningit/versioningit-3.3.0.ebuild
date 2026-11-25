# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="A setuptools plugin for versioning based on git tags"
HOMEPAGE="
	https://github.com/jwodder/versioningit/
	https://pypi.org/project/versioningit/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/packaging-17.1[${PYTHON_USEDEP}]
	dev-vcs/git
"
BDEPEND="
	test? (
		dev-python/pydantic[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# Tries to do wheel/pip installs
		test/test_end2end.py
	)

	if ! has_version "dev-python/pydantic[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			# Needs pydantic
			test/test_methods/test_hg.py
			test/test_methods/test_git.py
		)
	fi

	epytest -o addopts=
}
