# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="HTTrack Website Copier, Open Source Offline Browser"
HOMEPAGE="http://www.httrack.com/"
SRC_URI="http://mirror.httrack.com/historical/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND=">=sys-libs/zlib-1.2.5.1-r1
	dev-libs/openssl"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README greetings.txt history.txt )

src_prepare() {
	epatch "${FILESDIR}"/${P}-minizip.patch
}

src_configure() {
	econf $(use_enable static-libs static) \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
