# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="uEmacs/PK is an enhanced version of MicroEMACS"
HOMEPAGE="https://git.kernel.org/?p=editors/uemacs/uemacs.git;a=summary
	ftp://ftp.cs.helsinki.fi/pub/Software/Local/uEmacs-PK"
# snapshot from git repo
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/uemacs-${PV}.tar.xz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/uemacs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0.15_p20110825-gentoo.patch
}

src_compile() {
	emake V=1 \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_install() {
	dobin em
	insinto /usr/share/${PN}
	doins emacs.hlp
	newins emacs.rc .emacsrc
	dodoc README readme.39e emacs.ps UTF-8-demo.txt
}
