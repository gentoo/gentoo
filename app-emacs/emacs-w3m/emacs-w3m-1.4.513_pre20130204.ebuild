# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp autotools

DESCRIPTION="emacs-w3m is an interface program of w3m on Emacs"
HOMEPAGE="http://emacs-w3m.namazu.org/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="l10n_ja"

DEPEND="virtual/w3m"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
SITEFILE="70${PN}-gentoo.el"

src_prepare() {
	eautoreconf
}

src_configure() {
	default
}

src_compile() {
	emake all-en $(use l10n_ja && echo all-ja)
}

src_install() {
	emake lispdir="${ED}${SITELISP}/${PN}" \
		infodir="${ED}/usr/share/info" \
		ICONDIR="${ED}${SITEETC}/${PN}" \
		install-en $(use l10n_ja && echo install-ja) install-icons

	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	dodoc ChangeLog* NEWS README
	use l10n_ja && dodoc BUGS.ja NEWS.ja README.ja
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see ${EPREFIX}/usr/share/doc/${PF}/README*"
	einfo
	elog "If you want to use the shimbun library, please emerge app-emacs/apel"
	elog "and app-emacs/flim."
}
