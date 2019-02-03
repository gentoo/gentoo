# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit elisp-common ltprune

DESCRIPTION="Anthy -- free and secure Japanese input system"
HOMEPAGE="http://anthy.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/37536/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="canna-2ch emacs static-libs"

RDEPEND="canna-2ch? ( app-dicts/canna-2ch )
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-anthy_context_t.patch )
DOCS=( AUTHORS ChangeLog DIARY NEWS README )

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	if use canna-2ch; then
		einfo "Adding nichan.ctd to anthy.dic."
		sed -i "/set_input_encoding eucjp/aread ${EPREFIX}/var/lib/canna/dic/canna/nichan.ctd" mkworddic/dict.args.in
	fi
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		EMACS=$(usex emacs "${EMACS}")
}

src_install() {
	default
	prune_libtool_files

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	rm -f doc/Makefile*
	dodoc -r doc
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
