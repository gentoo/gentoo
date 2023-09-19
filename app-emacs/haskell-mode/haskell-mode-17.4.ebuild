# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Mode for editing (and running) Haskell programs in Emacs"
HOMEPAGE="https://haskell.github.io/haskell-mode/
	https://www.haskell.org/haskellwiki/Emacs#Haskell-mode"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/haskell/${PN}.git"
else
	SRC_URI="https://github.com/haskell/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

LICENSE="GPL-3+ FDL-1.2+"
SLOT="0"

BDEPEND="sys-apps/texinfo"

ELISP_REMOVE="
	tests/haskell-cabal-tests.el
	tests/haskell-customize-tests.el
	tests/haskell-lexeme-tests.el
"

DOCS=( NEWS README.md )
ELISP_TEXINFO="doc/${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	# We install the logo in SITEETC, not in SITELISP
	# https://github.com/haskell/haskell-mode/issues/102
	sed -i -e "/defconst haskell-process-logo/{n;" \
		-e "s:(.*\"\\(.*\\)\".*):\"${SITEETC}/${PN}/\\1\":}" \
		haskell-process.el || die

	elisp_src_prepare
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file haskell-site-file.el
}

src_test() {
	emake check-ert
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}"/${PN}
	doins logo.svg
}
