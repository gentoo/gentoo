# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmal/libmal-0.44.1.ebuild,v 1.9 2011/03/31 04:07:34 ssuominen Exp $

EAPI=4

DESCRIPTION="convenience library of the functions malsync distribution"
HOMEPAGE="http://www.jlogday.com/code/libmal/index.html"
SRC_URI="http://www.jlogday.com/code/libmal/${P}.tar.gz"

LICENSE="MPL-1.0"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 x86"
IUSE="static-libs"

RDEPEND=">=app-pda/pilot-link-0.12.3"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README"

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_install() {
	default

	docinto malsync
	dodoc malsync/{ChangeLog,README,Doc/README*} || die

	find "${D}" -name '*.la' -exec rm -f {} +
}
