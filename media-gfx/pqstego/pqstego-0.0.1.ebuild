# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pqstego/pqstego-0.0.1.ebuild,v 1.2 2010/11/08 22:57:45 maekke Exp $

EAPI=2

DESCRIPTION="Tools for Perturbed Quantization Steganography"
HOMEPAGE="http://sourceforge.net/projects/pqstego/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libpqstego
	virtual/jpeg:0"

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS CHANGES README
}
