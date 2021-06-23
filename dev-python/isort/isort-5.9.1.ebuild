# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="A python utility/library to sort imports"
HOMEPAGE="https://pypi.org/project/isort/"
SRC_URI="
	https://github.com/PyCQA/isort/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~x86"

RDEPEND="
	dev-python/toml[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/natsort[${PYTHON_USEDEP}]
		dev-python/pylama[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_tests pytest

src_prepare() {
	# unbundle toml
	sed -i -e 's:from ._vendored ::' isort/settings.py || die

	distutils-r1_src_prepare
}

python_test() {
	# Some tests run the "isort" command
	distutils_install_for_testing
	# Install necessary plugins
	local p
	for p in example*/; do
		pushd "${p}" >/dev/null || die
		distutils_install_for_testing
		popd >/dev/null || die
	done

	local deselect=(
		# Excluded from upstream's test script
		tests/unit/test_deprecated_finders.py
	)
	epytest tests/unit ${deselect[@]/#/--deselect }
}
