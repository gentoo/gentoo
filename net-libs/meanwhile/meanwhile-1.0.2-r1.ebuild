# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/meanwhile/meanwhile-1.0.2-r1.ebuild,v 1.9 2013/03/14 07:09:39 ago Exp $

EAPI=4
inherit eutils

DESCRIPTION="Meanwhile (Sametime protocol) library"
HOMEPAGE="http://meanwhile.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
IUSE="doc debug"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"

RDEPEND=">=dev-libs/glib-2:2"

DEPEND="${RDEPEND}
	dev-libs/gmp
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare(){
	epatch "${FILESDIR}/${P}-presence.patch" #239144
	epatch "${FILESDIR}/${P}-glib2.31.patch" #409081

	#241298
	sed -i -e "/sampledir/ s:-doc::" samples/Makefile.in || die
}

src_configure() {
	local myconf
	use doc || myconf="${myconf} --enable-doxygen=no"

	econf ${myconf} \
		--disable-static \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
