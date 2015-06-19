# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libcompizconfig/libcompizconfig-0.8.8.ebuild,v 1.3 2012/06/18 18:36:02 ssuominen Exp $

EAPI=4
inherit eutils

DESCRIPTION="Compiz Configuration System"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://releases.compiz.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	dev-libs/protobuf
	>=x11-wm/compiz-${PV}
	x11-libs/libX11"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.41
	virtual/pkgconfig
	x11-proto/xproto"

RESTRICT="test"

src_configure() {
	econf \
		--enable-fast-install \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc TODO
	prune_libtool_files --all
}
