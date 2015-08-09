# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils libtool autotools multilib

DESCRIPTION="Libtabe provides bimsphone support for xcin-2.5+"
HOMEPAGE="http://packages.qa.debian.org/libt/libtabe.html"
SRC_URI="mirror://debian/pool/main/libt/libtabe/${P/-/_}.orig.tar.gz
	mirror://debian/pool/main/libt/libtabe/${P/-/_}-1.1.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="debug"

DEPEND=">=sys-libs/db-4.5
	x11-libs/libX11"

S=${WORKDIR}/${P}.orig

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${P/-/_}-1.1.diff
	epatch "${FILESDIR}"/${P}-fabs.patch
	rm -f configure
	elibtoolize
	cd script
	eautoreconf
	cp script/* ./
	cp configure ../
	cd ..
}

src_compile() {
	myconf="--with-db-inc=/usr/include
		--with-db-lib=/usr/$(get_libdir)
		--with-db-bin=/usr/bin
		--with-db-name=db
		--enable-shared
		--disable-static
		$(use_enable debug)"

	econf ${myconf}
	emake -j1 || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc doc/*
}
