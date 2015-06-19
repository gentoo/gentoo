# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/dssi/dssi-1.1.1.ebuild,v 1.7 2013/03/02 21:42:29 hwoarang Exp $

EAPI=2
inherit autotools

DESCRIPTION="Plugin API for software instruments with user interfaces"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="qt4"

RDEPEND="media-libs/alsa-lib
	>=media-libs/liblo-0.12
	>=media-sound/jack-audio-connection-kit-0.99.14
	>=media-libs/ladspa-sdk-1.12-r2
	>=media-libs/libsndfile-1.0.11
	>=media-libs/libsamplerate-0.1.1-r1
	qt4? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}
	sys-apps/sed
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e 's:libdir=.*:libdir=@libdir@:' \
		dssi.pc.in || die

	if ! use qt4; then
		sed -i -e '/PKG_CHECK_MODULES(QT/s:QtGui:dIsAbLe&:' configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README doc/TODO doc/*.txt
	find "${D}" -name '*.la' -delete
}
