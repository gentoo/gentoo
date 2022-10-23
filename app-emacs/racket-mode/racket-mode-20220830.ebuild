# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=db7baebe64d5c1620c06e9bfca267a81ddc64aca
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Emacs modes for Racket: edit, REPL, check-syntax, debug, profile, and more"
HOMEPAGE="https://github.com/greghendershott/racket-mode/"
SRC_URI="https://github.com/greghendershott/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="dev-scheme/racket:=[-minimal]"
BDEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-rkt-source-dir.patch )

DOCS=( CONTRIBUTING.md README.md THANKS.md )

ELISP_TEXINFO="doc/racket-mode.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i racket-util.el || die
}

src_compile() {
	elisp_src_compile

	# Equivalent to compiling from Emacs with "racket-mode-start-faster",
	# because this is installed globally we have to compile it now.
	ebegin "Compiling Racket source files"
	find "${S}"/racket -type f -name "*.rkt" -exec raco make -v {} +
	eend $? "failed to compile Racket source files" || die
}

src_test() {
	# Set "PLTUSERHOME" to a safe temp directory to prevent writing to ~.
	PLTUSERHOME="${T}"/racket-mode/test-racket emake test-racket
}

src_install() {
	elisp_src_install

	# Install Racket files
	insinto "${SITEETC}/${PN}"
	doins -r racket
}
