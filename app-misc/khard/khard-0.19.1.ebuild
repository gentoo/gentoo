# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
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
	KEYWORDS="amd64 arm arm64 x86"
fi

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

distutils_enable_tests unittest
distutils_enable_sphinx docs \
	dev-python/sphinx-autoapi \
	dev-python/sphinx-autodoc-typehints

python_compile_all() {
	if use doc; then
		# The safe_MAKE= assignment below strips any arguments you might
		# have in your $MAKE variable (i.e. it keeps only the stuff
		# before the first space character). Sphinx tries to execute
		# $MAKE using subprocess.call, which is expecting an actual
		# program and not a program plus flags. This can help in some
		# corner cases, like MAKE="make LIBTOOL=..." in make.conf, and
		# should still allow e.g. MAKE=/usr/local/bin/mymake
		local safe_MAKE="${MAKE%% *}"
		[[ -z "${safe_MAKE}" ]] && safe_MAKE=make
		emake MAKE="${safe_MAKE}" -j1 -C doc/ html text man info
	fi
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
