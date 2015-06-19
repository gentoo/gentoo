# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/cpop/cpop-0.0.4-r1.ebuild,v 1.1 2014/10/26 19:57:41 mrueg Exp $

EAPI=5
inherit eutils

DESCRIPTION="GTK+ network popup message client. Compatible with the jpop protocol"
HOMEPAGE="http://www.draxil.uklinux.net/hip/index.pl?page=cpop"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-implicit-exit_memset_strlen.patch
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README
}
