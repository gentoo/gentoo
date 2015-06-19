# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gtypist/gtypist-2.9.2.ebuild,v 1.1 2013/01/13 14:58:18 ago Exp $

EAPI=4

inherit eutils elisp-common

DESCRIPTION="Universal typing tutor"
HOMEPAGE="http://www.gnu.org/software/gtypist/"
SRC_URI="mirror://gnu/gtypist/${P}.tar.xz
	http://colemak.com/pub/learn/colemak.typ"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux"
IUSE="nls emacs xemacs"

DEPEND=">=sys-libs/ncurses-5.2
	emacs? ( virtual/emacs )
	xemacs? ( !emacs? ( app-editors/xemacs app-xemacs/fsf-compat ) )"

RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

src_unpack() {
	unpack ${P}.tar.xz
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.8.3-xemacs-compat.patch
}

src_configure() {
	local lispdir=""
	if use emacs; then
		lispdir="${SITELISP}/${PN}"
		einfo "Configuring to build with GNU Emacs support"
	elif use xemacs; then
		lispdir="${EPREFIX}/usr/lib/xemacs/site-packages/lisp/${PN}"
		einfo "Configuring to build with XEmacs support"
	fi

	econf $(use_enable nls) \
		EMACS=$(usev emacs || usev xemacs || echo no) \
		--with-lispdir="${lispdir}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	insinto /usr/share/gtypist
	doins "${DISTDIR}"/colemak.typ

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
