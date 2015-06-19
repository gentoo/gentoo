# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xtscal/xtscal-0.6.3.ebuild,v 1.10 2015/06/05 14:48:57 chithanh Exp $

inherit autotools eutils

DESCRIPTION="Touchscreen calibration utility"
HOMEPAGE="http://gpe.linuxtogo.org/"
SRC_URI="http://gpe.linuxtogo.org/download/source/${P}.tar.bz2 mirror://gentoo/xtscal-0.6.3-patches-0.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXCalibrate
	x11-libs/libXft
	x11-proto/xcalibrateproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/patch/*.patch
	eautoreconf
}

src_install() {
	dobin xtscal || die
}
