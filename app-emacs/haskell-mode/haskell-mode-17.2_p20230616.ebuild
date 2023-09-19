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
	[[ ${PV} == *_p20230616 ]] && COMMIT=41c0cf61591279a22ac511f925c041c40969bdb8
	SRC_URI="https://github.com/haskell/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="amd64 ppc ~sparc x86"
fi

LICENSE="GPL-3+ FDL-1.2+"
SLOT="0"
RESTRICT="test"  # Tests fail.

BDEPEND="sys-apps/texinfo"

DOCS=( NEWS README.md )
ELISP_TEXINFO="doc/haskell-mode.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	# We install the logo in SITEETC, not in SITELISP
	# https://github.com/haskell/haskell-mode/issues/102
	sed -i -e "/defconst haskell-process-logo/{n;" \
		-e "s:(.*\"\\(.*\\)\".*):\"${SITEETC}/${PN}/\\1\":}" \
		haskell-process.el || die

	eapply_user
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
