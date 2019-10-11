# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils autotools

DESCRIPTION="Library for overlaying text in X-Windows X-On-Screen-Display"
HOMEPAGE="https://sourceforge.net/projects/libxosd/"
SRC_URI="mirror://debian/pool/main/x/xosd/${PN}_${PV}.orig.tar.gz
	https://dev.gentoo.org/~jer/${PN}_${PV}-1.diff.gz
	http://digilander.libero.it/dgp85/gentoo/${PN}-gentoo-m4-1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"
IUSE="xinerama"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	media-fonts/font-misc-misc"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-m4.patch
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${DISTDIR}"/${PN}_${PV}-1.diff.gz

	AT_M4DIR="${WORKDIR}/m4" eautoreconf
}

src_compile() {
	econf \
		$(use_enable xinerama)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
