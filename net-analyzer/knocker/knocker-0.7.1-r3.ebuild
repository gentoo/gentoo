# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/knocker/knocker-0.7.1-r3.ebuild,v 1.4 2015/01/26 10:14:39 ago Exp $

EAPI=5

inherit base toolchain-funcs

DESCRIPTION="Knocker is an easy to use security port scanner written in C"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://knocker.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

DOCS=( AUTHORS BUGS ChangeLog NEWS README TO-DO )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-fency.patch \
		"${FILESDIR}"/${P}-free.patch \
		"${FILESDIR}"/${P}-knocker_user_is_root.patch

	tc-export CC
}
