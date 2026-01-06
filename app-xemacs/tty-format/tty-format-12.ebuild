# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Text file backspacing and ANSI SGR as faces"
HOMEPAGE="https://user42.tuxfamily.org/tty-format/index.html
	https://www.emacswiki.org/emacs/TtyFormat"
# taken from https://download.tuxfamily.org/user42/tty-format.el"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"
S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-editors/xemacs-21.5.35
	app-xemacs/text-modes"
BDEPEND="${RDEPEND}"

EMACS="${EPREFIX}/usr/bin/xemacs"
EMACSFLAGS="-batch -q -no-site-file"

src_unpack() {
	default
	mv ${P}.el ${PN}.el || die
}

src_compile() {
	${EMACS} ${EMACSFLAGS} -f batch-byte-compile tty-format.el || die
	${EMACS} ${EMACSFLAGS} \
		-eval "(setq autoload-package-name \"${PN}\")" \
		-eval "(setq generated-autoload-file \"${S}/auto-autoloads.el\")" \
		-l autoload -f batch-update-autoloads tty-format.el || die
}

src_install() {
	insinto /usr/lib/xemacs/site-packages/lisp/${PN}
	doins tty-format.{el,elc} auto-autoloads.el
}
