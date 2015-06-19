# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/enet/enet-1.3.12.ebuild,v 1.1 2015/02/27 09:57:49 xmw Exp $

EAPI=5

inherit base

DESCRIPTION="relatively thin, simple and robust network communication layer on top of UDP"
HOMEPAGE="http://enet.bespin.org/"
SRC_URI="http://enet.bespin.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="1.3/2.2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="static-libs"

RDEPEND="!${CATEGORY}/${PN}:0"

DOCS=( "ChangeLog" "README" )

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_install() {
	base_src_install
	if ! use static-libs ; then
		find "${D}" -type f -name '*.la' -exec rm {} + || die
	fi
}
