# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Style checker for Sphinx (or other) RST documentation"
HOMEPAGE="
	https://pypi.org/project/doc8/
	https://github.com/PyCQA/doc8/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/docutils-0.19[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/restructuredtext-lint-0.7[${PYTHON_USEDEP}]
	dev-python/stevedore[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	# unpin docutils
	sed -i -e '/docutils/s:,<=[0-9.]*::' pyproject.toml || die
}
