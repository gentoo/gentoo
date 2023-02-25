# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=hatchling

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	>=dev-python/mkdocs_pymdownx_material_extras-2.0
	dev-python/mkdocs-material
	dev-python/mkdocs-git-revision-date-localized-plugin
	dev-python/mkdocs-minify-plugin
	dev-python/pyspelling
"

inherit distutils-r1 docs

DESCRIPTION="Wildcard/glob file name matcher"
HOMEPAGE="
	https://github.com/facelessuser/wcmatch/
	https://pypi.org/project/wcmatch/
"
SRC_URI="
	https://github.com/facelessuser/wcmatch/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86"

RDEPEND="
	>=dev-python/bracex-2.1.1[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-vcs/git
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# tests require some files in homedir
	> "${HOME}"/test1.txt || die
	> "${HOME}"/test2.txt || die

	# mkdocs-git-revision-date-localized-plugin needs git repo
	if use doc; then
		git init || die
		git config --global user.email "larry@gentoo.org" || die
		git config --global user.name "Larry the Cow" || die
		git add . || die
		git commit -m 'init' || die
	fi

	distutils-r1_python_prepare_all
}
