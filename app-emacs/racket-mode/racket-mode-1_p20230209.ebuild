# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20230209 ]] && COMMIT=947d9806ee27ef241643f978c7901fd1f9e10c98
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Emacs modes for Racket: edit, REPL, check-syntax, debug, profile, and more"
HOMEPAGE="https://www.racket-mode.com/
	https://github.com/greghendershott/racket-mode/"
SRC_URI="https://github.com/greghendershott/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-scheme/racket:=[-minimal]"
BDEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-rkt-source-dir.patch )

DOCS=( CONTRIBUTING.org README.org THANKS.org )

ELISP_TEXINFO="doc/racket-mode.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i "${S}"/racket-util.el || die
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

	# Install Racket files to "${SITEETC}".
	insinto "${SITEETC}/${PN}"
	doins -r racket
}
