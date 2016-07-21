# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Add Info-like navigation keys to the emacs-w3m web browser"
HOMEPAGE="http://www.neilvandyke.org/w3mnav/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="app-emacs/emacs-w3m"
RDEPEND="${DEPEND}"

SITEFILE="75${PN}-gentoo.el"

src_compile() {
	${EMACS} ${EMACSFLAGS} -L "${SITELISP}/emacs-w3m" \
		-f batch-byte-compile w3mnav.el || die "byte-compile failed"
}
