# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="dev-python/mkdocs-material"

inherit distutils-r1 docs

DESCRIPTION="Mkdocs plugin to display git authors of a page"
HOMEPAGE="
	https://github.com/timvink/mkdocs-git-authors-plugin/
	https://pypi.org/project/mkdocs-git-authors-plugin/
"
SRC_URI="https://github.com/timvink/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

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
	doc? ( dev-vcs/git )
"

distutils_enable_tests pytest

python_prepare_all() {
	# mkdocs-git-authors tests need git repo
	if use test || use doc; then
		git init -q || die
		git config --global user.email "you@example.com" || die
		git config --global user.name "Your Name" || die
		git add . || die
		git commit -qm 'init' || die
	fi

	distutils-r1_python_prepare_all
}
