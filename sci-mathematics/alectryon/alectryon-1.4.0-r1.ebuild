# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit elisp-common distutils-r1

DESCRIPTION="Toolkit for literate programming in Coq"
HOMEPAGE="https://github.com/cpitclaudel/alectryon/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cpitclaudel/${PN}.git"
else
	SRC_URI="https://github.com/cpitclaudel/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc emacs"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/dominate[${PYTHON_USEDEP}]
	dev-python/myst_parser[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	sci-mathematics/coq-serapi
"
DEPEND="${RDEPEND}"
BDEPEND="
	emacs? (
		>=app-editors/emacs-23.1:*
		app-emacs/flycheck
		app-emacs/proofgeneral
	)
"

DOCS=( CHANGES.rst CITATION.bib README.rst )
PATCHES=( "${FILESDIR}"/${P}-setup.cfg-version.patch )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	distutils-r1_src_compile

	use doc && emake -C ./recipes/sphinx latexpdf
	use emacs && elisp-compile ./etc/elisp/alectryon.el
}

src_install() {
	distutils-r1_src_install
	einstalldocs

	if use doc ; then
		docinto html
		dodoc ./recipes/sphinx/_build/html/*
		docinto pdf
		dodoc ./recipes/sphinx/_build/latex/alectryon-demo.pdf
		docinto latex
		dodoc ./recipes/sphinx/_build/latex/alectryon-demo.tex
	fi
	if use emacs ; then
		elisp-install ${PN} ./etc/elisp/${PN}.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
