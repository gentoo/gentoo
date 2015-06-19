# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/librtas/librtas-1.3.8.ebuild,v 1.1 2013/02/27 20:49:25 ranger Exp $

EAPI=4
inherit eutils

DESCRIPTION="A set of libraries for userspace access to RTAS on the PowerPC platform(s)"
HOMEPAGE="http://sourceforge.net/projects/librtas/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="IBM"
SLOT="0"
KEYWORDS="~ppc ~ppc64"
IUSE=""

DOCS="README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-symlink.patch
	sed -i -e '/install_doc/d' Makefile || die
}
