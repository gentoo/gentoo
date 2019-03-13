# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
NEED_EMACS=24

inherit readme.gentoo-r1 elisp

DESCRIPTION="Collaborative editing environment for GNU Emacs"
HOMEPAGE="http://rudel.sourceforge.net/
	https://www.emacswiki.org/emacs/Rudel"
# snapshot of bzr://rudel.bzr.sourceforge.net/bzrroot/rudel/trunk
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"
ELISP_PATCHES="${P}-emacs25.patch"
SITEFILE="60${PN}-gentoo.el"

src_compile() {
	${EMACS} ${EMACSFLAGS} -l rudel-compile.el || die
}

src_install() {
	local dir

	for dir in . adopted infinote jupiter obby socket telepathy tls \
		xmpp zeroconf
	do
		insinto "${SITELISP}/${PN}/${dir}"
		doins ${dir}/*.{el,elc}
	done

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto "${SITEETC}/${PN}"
	doins -r icons

	dodoc README INSTALL ChangeLog TODO doc/card.pdf

	DOC_CONTENTS="Connections to Gobby servers require the gnutls-cli program
		(net-libs/gnutls).
		\\n\\nThe Avahi daemon (net-dns/avahi) is required for automatic
		session discovery and advertising."
	readme.gentoo_create_doc
}
