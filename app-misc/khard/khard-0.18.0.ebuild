# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Console CardDAV client"
HOMEPAGE="
	https://github.com/lucc/khard
	https://pypi.org/project/khard/
"

LICENSE="GPL-3"
SLOT="0"

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lucc/khard"
else
	inherit pypi
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

IUSE=""

RDEPEND="
	dev-python/atomicwrites[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml-clib[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/vobject[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/sphinx-autoapi
		dev-python/sphinx-rtd-theme
		dev-python/sphinx-autodoc-typehints
	)
"

DOCS=(
	CHANGES
	CONTRIBUTING.rst
	README.md
	doc/source/examples/khard.conf.example
)

distutils_enable_tests setup.py
distutils_enable_sphinx docs

python_compile_all() {
	use doc && emake -j1 -C doc/ html text man info
}

python_install_all() {
	if use doc; then
		DOCS+=( doc/build/text/. )
		HTML_DOCS+=( doc/build/html/. )

		doman doc/build/man/*
		doinfo doc/build/texinfo/*.info
	fi

	insinto /usr/share/zsh/site-functions
	doins misc/zsh/_khard

    distutils-r1_python_install_all
}
