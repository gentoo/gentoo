# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/mkdocs-git-revision-date-localized-plugin
	dev-python/mkdocs-material
	dev-python/mkdocs-minify-plugin
	dev-python/mkdocs_pymdownx_material_extras
	dev-python/pyspelling
"

inherit distutils-r1 docs

DESCRIPTION="Bash style brace expansion for Python"
HOMEPAGE="
	https://github.com/facelessuser/bracex/
	https://pypi.org/project/bracex/
"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

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
