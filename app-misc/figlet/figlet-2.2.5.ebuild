# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/figlet/figlet-2.2.5.ebuild,v 1.7 2014/10/27 15:58:05 ago Exp $

EAPI=5
inherit eutils bash-completion-r1 toolchain-funcs

DESCRIPTION="program for making large letters out of ordinary text"
HOMEPAGE="http://www.figlet.org/"
SRC_URI="ftp://ftp.figlet.org/pub/figlet/program/unix/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

src_compile() {
	emake clean
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
	    LDFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		all
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		BINDIR="${EPREFIX}/usr/bin" \
		MANDIR="${EPREFIX}/usr/share/man" \
		prefix="${EPREFIX}/usr" \
		install

	doman chkfont.6 figlet.6 figlist.6 showfigfonts.6
	dodoc README figfont.txt

	dobashcomp "${FILESDIR}"/figlet.bashcomp
}
