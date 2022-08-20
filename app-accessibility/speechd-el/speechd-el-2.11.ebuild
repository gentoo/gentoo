# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature readme.gentoo-r1 elisp

DESCRIPTION="Emacs speech support"
HOMEPAGE="https://www.freebsoft.org/speechd-el
	https://github.com/brailcom/speechd-el"
SRC_URI="https://github.com/brailcom/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}"/${PN}-${P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=app-accessibility/speech-dispatcher-0.7"

DOC_CONTENTS="To get Emacs to speak execute:
M-x speechd-speak RET

or add following to your initialization file (~/.emacs):
(speechd-speak)"
DISABLE_AUTOFORMATTING=YES

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake
}

src_install() {
	elisp_src_install

	dobin speechd-log-extractor
	dodoc ANNOUNCE NEWS README speechd-speak.pdf
	doinfo ${PN}.info
}

pkg_postinst() {
	elisp_pkg_postinst

	optfeature "braille support" "app-accessibility/brltty"
}
