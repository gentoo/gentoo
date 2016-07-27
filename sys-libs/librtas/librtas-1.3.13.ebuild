# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A set of libraries for userspace access to RTAS on the PowerPC platform(s)"
HOMEPAGE="https://sourceforge.net/projects/librtas/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="IBM"
SLOT="0"
KEYWORDS="~ppc ~ppc64"

DOCS="README"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3.8-symlink.patch
	sed -i -e '/install_doc/d' Makefile || die
}
