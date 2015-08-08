# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib elisp-common

DESCRIPTION="Shared library implementing a Lisp dialect"
HOMEPAGE="http://librep.sourceforge.net/"
SRC_URI="http://download.tuxfamily.org/librep/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="emacs readline"

RDEPEND="
	>=sys-libs/gdbm-1.8.0
	emacs? ( virtual/emacs )
	readline? ( sys-libs/readline )
"
DEPEND="${RDEPEND}
	sys-apps/texinfo
	app-arch/xz-utils
"

src_prepare() {
	DOCS="ChangeLog MAINTAINERS NEWS README TODO"
	epatch "${FILESDIR}"/${PN}-0.92.0-disable-elisp.patch
}

src_configure() {
	econf \
		--libexecdir=/usr/$(get_libdir) \
		--without-gmp \
		--without-ffi \
		--disable-static \
		$(use_with readline)
}

src_compile() {
	default

	if use emacs; then
		elisp-compile rep-debugger.el || die "elisp-compile failed"
	fi
}

src_install() {
	default
	prune_libtool_files --modules

	docinto doc
	dodoc doc/*

	if use emacs; then
		elisp-install ${PN} rep-debugger.{el,elc} || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el" \
			|| die "elisp-site-file-install failed"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
