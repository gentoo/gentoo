# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/dvi2tty/dvi2tty-5.3.4.ebuild,v 1.10 2012/05/28 13:59:09 armin76 Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Preview dvi-files on text-only devices"
HOMEPAGE="http://www.ctan.org/tex-archive/dviware/"
SRC_URI="ftp://ftp.mesa.nl/pub/dvi2tty/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch
}

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin dvi2tty disdvi
	doman dvi2tty.1 disdvi.1
	dodoc README TODO
}
