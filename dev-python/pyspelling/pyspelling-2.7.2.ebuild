# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS=rdepend

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	~dev-python/mkdocs_pymdownx_material_extras-1.1.3
	dev-python/mkdocs-git-revision-date-localized-plugin
	dev-python/mkdocs-minify-plugin
"

inherit distutils-r1 docs

DESCRIPTION="Spell checker automation tool"
HOMEPAGE="https://github.com/facelessuser/pyspelling"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| ( app-text/aspell app-text/hunspell )

	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/soupsieve-1.8[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-6.0.3[${PYTHON_USEDEP}]
"

BDEPEND="test? ( dev-vcs/git )"

distutils_enable_tests pytest

python_prepare_all() {
	# mkdocs-git-revision-date-localized-plugin needs git repo
	if use doc; then
		git init || die
		git config --global user.email "you@example.com" || die
		git config --global user.name "Your Name" || die
		git add . || die
		git commit -m 'init' || die
	fi

	distutils-r1_python_prepare_all
}
