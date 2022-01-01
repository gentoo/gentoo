# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Emacs speech support"
HOMEPAGE="http://www.freebsoft.org/speechd-el"
SRC_URI="http://www.freebsoft.org/pub/projects/speechd-el/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=app-accessibility/speech-dispatcher-0.7"

src_compile() {
	emake
}

src_install() {
	elisp-install ${PN} *.el *.elc
	dobin speechd-log-extractor
	dodoc ANNOUNCE NEWS README speechd-speak.pdf
	doinfo speechd-el.info
}

pkg_postinst() {
	elog "Execute the following commands from within emacs to get it to speak:"
	elog "  M-x load-library RET speechd-speak RET"
	elog "  M-x speechd-speak RET"
	elog
	elog "or add the following to your ~/.emacs file:"
	elog
	elog "(autoload 'speechd-speak \"speechd-speak\" nil t)"
	elog '(speechd-speak)'
	elog
	elog "Also, if you nead braille support, you will need to install"
	elog "app-accessibility/brltty"
}
