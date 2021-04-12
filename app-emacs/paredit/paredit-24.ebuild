# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Minor mode for performing structured editing of S-expressions"
HOMEPAGE="https://mumble.net/~campbell/emacs/
	https://www.emacswiki.org/emacs/ParEdit"
# No documentation available for paredit-24, so take previous version
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz
	https://dev.gentoo.org/~ulm/distfiles/${PN}-23.html.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	elisp_src_unpack
	mv ${PN}-23.html ${PN}.html || die
}

src_install() {
	elisp_src_install
	docinto html
	dodoc *.html
}
