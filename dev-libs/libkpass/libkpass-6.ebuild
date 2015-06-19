# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libkpass/libkpass-6.ebuild,v 1.4 2013/10/23 14:09:45 joker Exp $

EAPI=5

DESCRIPTION="Libkpass is a from-scratch C implementation of accessing KeePass 1.x format password databases"
HOMEPAGE="http://libkpass.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND=">=dev-libs/nettle-2.7.1"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog README TODO )

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || rm -f "${ED}"/usr/lib*/${PN}.la
}
