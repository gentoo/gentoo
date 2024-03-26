# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == *p20240130 ]] && COMMIT=d3ab936af10909874443cadb2e6c952faf2f536f

inherit elisp # virtualx

DESCRIPTION="Emacs modes for Racket: edit, REPL, check-syntax, debug, profile, and more"
HOMEPAGE="https://www.racket-mode.com/
	https://github.com/greghendershott/racket-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/greghendershott/${PN}.git"
else
	SRC_URI="https://github.com/greghendershott/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-scheme/racket:=[-minimal]
"
BDEPEND="
	${RDEPEND}
"

ELISP_REMOVE="
	test/racket/hash-lang-test.rkt
"
PATCHES=( "${FILESDIR}/${PN}-rkt-source-dir.patch" )

DOCS=( CONTRIBUTING.org README.org THANKS.org )
ELISP_TEXINFO="doc/${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i "${S}/racket-util.el" || die
}

src_compile() {
	elisp_src_compile

	# Equivalent to compiling from Emacs with "racket-mode-start-faster",
	# because this is installed globally we have to compile it now.
	ebegin "Compiling Racket source files"
	find "${S}/racket" -type f -name "*.rkt" -exec raco make -v {} +
	eend $? "failed to compile Racket source files" || die
}

src_test() {
	# Set "PLTUSERHOME" to a safe temp directory to prevent writing to "~".
	PLTUSERHOME="${T}/racket-mode/test-racket" emake test-racket
}

src_install() {
	elisp_src_install

	# Install Racket files to "${SITEETC}".
	insinto "${SITEETC}/${PN}"
	doins -r racket
}
