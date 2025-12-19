# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..13} )

inherit elisp distutils-r1

DESCRIPTION="A tool that allows both-side communication between Python and Emacs Lisp"
HOMEPAGE="https://www.emacswiki.org/emacs/PyMacs
	https://github.com/dgentry/Pymacs/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dgentry/${PN^}.git"
else
	SRC_URI="https://github.com/dgentry/${PN^}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="amd64 arm ~hppa ppc ppc64 x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc"

BDEPEND="
	doc? (
		>=dev-python/docutils-0.7
		virtual/latex-base
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.26-setup.patch" )

DOCS=( "${PN}.rst" )
SITEFILE="50${PN}-gentoo.el"

python_configure() {
	emake PYSETUP=":" PYTHON="${EPYTHON}" prepare
}

src_compile() {
	distutils-r1_src_compile
	elisp_src_compile

	if use doc; then
		# docutils 0.21.1 renamed rst2latex.py to rst2latex
		local r2l=$(command -v rst2latex || command -v rst2latex.py || die)
		VARTEXFONTS="${T}"/fonts emake RST2LATEX="${r2l}" ${PN}.pdf
	fi
}

src_install() {
	distutils-r1_src_install
	elisp_src_install

	use doc && dodoc ${PN}.pdf
}
