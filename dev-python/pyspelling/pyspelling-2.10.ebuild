# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=hatchling

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	>=dev-python/mkdocs-pymdownx-material-extras-2.1
	dev-python/mkdocs-git-revision-date-localized-plugin
	dev-python/mkdocs-minify-plugin
"

inherit distutils-r1 docs

DESCRIPTION="Spell checker automation tool"
HOMEPAGE="
	https://github.com/facelessuser/pyspelling/
	https://pypi.org/project/pyspelling/
"
SRC_URI="
	https://github.com/facelessuser/pyspelling/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	|| ( app-text/aspell app-text/hunspell )

	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/soupsieve-1.8[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-6.5[${PYTHON_USEDEP}]
"
# The package can use either aspell or hunspell but tests both if both
# are installed.  Therefore, we need to ensure that both have English
# dictionary installed.
BDEPEND="
	test? (
		app-dicts/aspell-en
		app-dicts/myspell-en
		dev-vcs/git
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# mkdocs-git-revision-date-localized-plugin needs git repo
	if use doc; then
		git init -q || die
		git config --global user.email "you@example.com" || die
		git config --global user.name "Your Name" || die
		git add . || die
		git commit -q -m 'init' || die
	fi

	distutils-r1_python_prepare_all
}
