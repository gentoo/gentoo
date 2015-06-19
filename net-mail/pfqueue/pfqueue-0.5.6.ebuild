# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pfqueue/pfqueue-0.5.6.ebuild,v 1.8 2014/11/15 00:57:34 jer Exp $

EAPI=5
inherit autotools eutils toolchain-funcs

DESCRIPTION="pfqueue is an ncurses console-based tool for managing Postfix queued messages"
HOMEPAGE="http://pfqueue.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	sys-libs/ncurses
	sys-devel/libtool
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

src_configure() {
	econf --disable-static
}

DOCS=( README ChangeLog NEWS TODO AUTHORS )

src_install() {
	default
	prune_libtool_files
}
