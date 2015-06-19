# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/compface/compface-1.5.2.ebuild,v 1.18 2014/12/30 18:12:45 maekke Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Utilities and library to convert to/from X-Face format"
HOMEPAGE="http://www.xemacs.org/Download/optLibs.html"
SRC_URI="http://ftp.xemacs.org/pub/xemacs/aux/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.diff
	sed -i "/strip/d" Makefile.in
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog README
	newbin xbm2xface{.pl,}
}
