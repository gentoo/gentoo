# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/anthy/anthy-9100h-r1.ebuild,v 1.11 2015/01/04 03:43:04 heroxbd Exp $

EAPI=3
inherit elisp-common eutils

DESCRIPTION="Anthy -- free and secure Japanese input system"
HOMEPAGE="http://anthy.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/anthy/37536/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
#KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
IUSE="canna-2ch emacs static-libs"

DEPEND="!app-i18n/anthy-ss
	canna-2ch? ( app-dicts/canna-2ch )
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-anthy_context_t.patch"

	if use canna-2ch; then
		einfo "Adding nichan.ctd to anthy.dic."
		sed -i \
			-e "/set_input_encoding eucjp/aread ${EPREFIX}/var/lib/canna/dic/canna/nichan.ctd" \
			mkworddic/dict.args.in || die
	fi
}

src_configure() {
	local myconf

	use emacs || myconf="EMACS=no"

	econf \
		$(use_enable static-libs static) \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use emacs ; then
		elisp-site-file-install "${FILESDIR}"/50anthy-gentoo.el || die
	fi

	dodoc AUTHORS DIARY NEWS README ChangeLog || die

	rm -f doc/Makefile*
	docinto doc
	dodoc doc/* || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
