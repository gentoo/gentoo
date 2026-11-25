# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9
NEED_EMACS="29.1"

inherit elisp toolchain-funcs

DESCRIPTION="XMPP client for Emacs"
HOMEPAGE="https://xmpp.org/software/jabber-el/"
SRC_URI="https://codeberg.org/emacs-jabber/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-editors/emacs-29.1:*[dynamic-loading,sqlite]
	app-emacs/fsm
	app-emacs/keymap-popup
	net-libs/mbedtls:3="
DEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo-0.11.0.el"

pkg_setup() {
	elisp-check-emacs-version

	local i missing feat=(
		dynamic-loading "(fboundp 'module-load)"
		sqlite "(sqlite-available-p)"
	)

	for (( i=0; i<${#feat[@]}; i+=2 )); do
		[[ $(${EMACS} ${EMACSFLAGS} --eval "(princ ${feat[i+1]})") = t ]] \
			|| missing+="${missing:+ }${feat[i]}"
	done
	if [[ -n ${missing} ]]; then
		eerror "${CATEGORY}/${PN} needs ${missing// / and } support in Emacs"
		eerror "Emerge app-editors/emacs with USE=\"${missing}\""
		die "Emacs misses at least one feature"
	fi
}

src_compile() {
	local MBED_FLAGS
	MBED_FLAGS=$("$(tc-getPKG_CONFIG)" --cflags --libs mbedcrypto-3) || die
	emake \
		CC="$(tc-getCC)" \
		EMACS_CMD="${EMACS}" \
		EMACS_OPTS="${EMACSFLAGS}" \
		MBED_FLAGS="${MBED_FLAGS}"
}

src_test() {
	local tests=( tests/jabber-test-*.el )
	elisp-test-ert tests -L lisp "${tests[@]/#/--load=}"
}

src_install() {
	elisp-install ${PN} lisp/*.{el,elc}
	elisp-modules-install ${PN} lisp/jabber-omemo-core.so
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc README.org CHANGELOG.org
}
