# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ilmbase/ilmbase-1.0.2.ebuild,v 1.11 2015/08/06 16:46:38 klausman Exp $

EAPI=2
inherit eutils libtool

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 -arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

RDEPEND="!<media-libs/openexr-1.5.0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.0-asneeded.patch \
		"${FILESDIR}"/${P}-gcc43.patch
	elibtoolize
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
	find "${D}" -name '*.la' -delete
}
