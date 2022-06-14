# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Console CardDAV client"
HOMEPAGE="https://github.com/scheibler/khard"

LICENSE="GPL-3"
SLOT="0"

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scheibler/khard"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 x86"
fi

IUSE="doc"

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
		dev-python/setuptools_scm[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/sphinx
		dev-python/sphinx-autoapi
		dev-python/sphinx-autodoc-typehints
	)
"

DOCS=( CHANGES CONTRIBUTING.rst README.md doc/source/examples/khard.conf.example )

distutils_enable_tests setup.py

src_compile() {
	distutils-r1_src_compile

	if use doc; then
		emake -j1 -C doc/ html text man info
	fi
}

src_install() {
	if use doc; then
		DOCS+=( doc/build/text/. )
		HTML_DOCS+=( doc/build/html/. )

		doman doc/build/man/*
		doinfo doc/build/texinfo/*.info
	fi

	distutils-r1_src_install

	insinto /usr/share/zsh/site-functions
	doins misc/zsh/_khard
}
