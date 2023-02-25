# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} )

# Requires self to be installed to build docs
# TODO: Do this a bit better
DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/regex
	dev-python/mkdocs-material
	dev-python/mkdocs-git-authors-plugin
"
DOCS_INITIALIZE_GIT=1

inherit distutils-r1 docs

DESCRIPTION="Mkdocs plugin to display git authors of a page"
HOMEPAGE="
	https://github.com/timvink/mkdocs-git-authors-plugin/
	https://pypi.org/project/mkdocs-git-authors-plugin/
"
SRC_URI="https://github.com/timvink/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86"

# Tests are broken outside of upstream git repo
RESTRICT="test"

RDEPEND="
	dev-python/GitPython[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		dev-python/mkdocs-git-revision-date-localized-plugin[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# mkdocs-git-authors tests need git repo
	use test && initialize_git_repo

	distutils-r1_python_prepare_all
}
