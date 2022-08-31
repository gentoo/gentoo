# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="MIT/GNU Scheme's implementation of the Geiser protocols"
HOMEPAGE="https://gitlab.com/emacs-geiser/mit/"
SRC_URI="https://gitlab.com/emacs-geiser/mit/-/archive/${PV}/mit-${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/mit-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-emacs/geiser
	dev-scheme/mit-scheme
"
BDEPEND="${RDEPEND}"

DOCS=( readme.org )
PATCHES=( "${FILESDIR}"/${PN}-src-dir.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i ${PN}.el || die
}

src_compile() {
	elisp_src_compile

	local scms=$(find "${S}" -type f -name "*.scm")
	local opts=(
		--interactive
		--eval "(for-each (lambda (s) (load (symbol->string s))) '(${scms}))"
		--eval "(for-each (lambda (s) (cf (symbol->string s))) '(${scms}))"
		--eval "(exit)"
	)
	mit-scheme "${opts[@]}" || die "failed to compile scheme source files"
}

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}
	doins -r src
}
