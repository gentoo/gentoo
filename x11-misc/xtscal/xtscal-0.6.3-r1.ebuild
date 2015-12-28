# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Touchscreen calibration utility"
HOMEPAGE="http://gpe.linuxtogo.org/"
SRC_URI="http://gpe.linuxtogo.org/download/source/${P}.tar.bz2 mirror://gentoo/xtscal-0.6.3-patches-0.2.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXCalibrate
	x11-libs/libXft
	x11-proto/xcalibrateproto"

src_prepare() {
	epatch "${WORKDIR}"/patch/*.patch
	eautoreconf
}

src_install() {
	dobin xtscal
}
