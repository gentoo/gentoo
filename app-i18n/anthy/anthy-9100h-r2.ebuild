# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp-common

DESCRIPTION="Anthy -- free and secure Japanese input system"
HOMEPAGE="http://anthy.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/anthy/37536/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
IUSE="canna-2ch emacs static-libs"

DEPEND="
	!app-i18n/anthy-ss
	canna-2ch? ( app-dicts/canna-2ch )
	emacs? ( virtual/emacs )"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-anthy_context_t.patch" )

DOCS=( AUTHORS DIARY NEWS README ChangeLog )

src_prepare() {
	default

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
		${myconf}
}

src_install() {
	default

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/50anthy-gentoo.el || die
	fi

	rm -v doc/Makefile* || die
	docinto doc
	dodoc doc/*
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
