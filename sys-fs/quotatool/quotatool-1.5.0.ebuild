# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/quotatool/quotatool-1.5.0.ebuild,v 1.1 2013/09/05 08:29:31 radhermit Exp $

EAPI="4"

inherit eutils

DESCRIPTION="command-line utility for filesystem quotas"
HOMEPAGE="http://quotatool.ekenberg.se/"
SRC_URI="http://quotatool.ekenberg.se/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="sys-fs/quota"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.13-ldflags.patch
}

src_install () {
	dodir /usr/sbin /usr/share/man/man8
	default
}
