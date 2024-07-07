# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..13} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/regex
	dev-python/mkdocs-static-i18n
	dev-python/mkdocs-material
	dev-python/mkdocs-git-authors-plugin
	dev-python/mkdocs-git-revision-date-localized-plugin
"

inherit distutils-r1 docs

DESCRIPTION="Display the localized date of the last git modification of a markdown file"
HOMEPAGE="
	https://github.com/timvink/mkdocs-git-revision-date-localized-plugin/
	https://pypi.org/project/mkdocs-git-revision-date-localized-plugin/
"
SRC_URI="
	https://github.com/timvink/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/Babel-2.7.0[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		dev-python/mkdocs-static-i18n[${PYTHON_USEDEP}]
		dev-vcs/git
	)
	doc? ( dev-vcs/git )
"

distutils_enable_tests pytest

python_prepare_all() {
	# mkdocs-git-revision-date-localized-plugin's tests need git repo
	if use test || use doc; then
		git init -q || die
		git config --global user.email "larry@gentoo.org" || die
		git config --global user.name "Larry the Cow" || die
		git add . || die
		git commit -qm 'init' || die
	fi

	distutils-r1_python_prepare_all
}
