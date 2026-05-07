# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{13..14} )

inherit elisp-common distutils-r1

DESCRIPTION="Toolkit for literate programming in Coq/Rocq"
HOMEPAGE="https://github.com/cpitclaudel/alectryon/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/cpitclaudel/${PN}"
else
	SRC_URI="https://github.com/cpitclaudel/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc emacs"

RDEPEND="
	>=dev-python/beautifulsoup4-4.11.2[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.19[${PYTHON_USEDEP}]
	>=dev-python/dominate-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/myst-parser-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.14.0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-6.1.3[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	doc? (
		dev-texlive/texlive-xetex
		media-fonts/fira-code
		media-fonts/libertine
	)
	emacs? (
		app-emacs/flycheck
		app-emacs/proofgeneral
	)
"

DOCS=( CHANGES.rst CITATION.bib README.rst )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	# This apparently cleans latex run clutter. We do not need it.
	sed -e "s|texfot --tee=/dev/null --no-stderr||g" \
		-i ./recipes/Makefile ./recipes/sphinx/Makefile \
		|| die

	# Needs unpackaged binaries.
	sed -e "s|test_validation|__test_validation|g" \
		-i ./recipes/tests/unit.py \
		|| die

	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile

	if use emacs ; then
		elisp-compile ./etc/elisp/alectryon.el
	fi

	if use doc ; then
		emake -C ./recipes/sphinx TEXFOT="" latexpdf
	fi
}

python_test() {
	"${EPYTHON}" -m unittest -v ./recipes/tests/unit.py \
		|| die "Tests failed with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install
	einstalldocs

	if use emacs ; then
		elisp-install "${PN}" ./etc/elisp/${PN}.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use doc ; then
		docinto html
		dodoc ./recipes/sphinx/_build/html/*
		docinto pdf
		dodoc ./recipes/sphinx/_build/latex/alectryon-demo.pdf
		docinto latex
		dodoc ./recipes/sphinx/_build/latex/alectryon-demo.tex
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
