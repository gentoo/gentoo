# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libclastfm/libclastfm-0.5.ebuild,v 1.2 2012/06/18 16:19:54 ssuominen Exp $

EAPI=4

DESCRIPTION="C API library to the last.fm web service (unofficial)"
HOMEPAGE="http://liblastfm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/c}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS README"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/*.la
}
