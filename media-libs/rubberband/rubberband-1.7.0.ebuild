# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/rubberband/rubberband-1.7.0.ebuild,v 1.3 2012/05/05 08:02:38 jdhore Exp $

EAPI=4
inherit multilib

DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
HOMEPAGE="http://www.breakfastquay.com/rubberband/"
SRC_URI="http://code.breakfastquay.com/attachments/download/23/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="static-libs"

RDEPEND="media-libs/vamp-plugin-sdk
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/ladspa-sdk
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if ! use static-libs ; then
		sed -i -e '/^all:/s/$(STATIC_TARGET)//' \
			-e '/^\tcp $(STATIC_TARGET)/d' \
			Makefile.in || die
	fi
}

src_install() {
	emake INSTALL_BINDIR="${D}/usr/bin" \
		INSTALL_INCDIR="${D}/usr/include/rubberband" \
		INSTALL_LIBDIR="${D}/usr/$(get_libdir)" \
		INSTALL_VAMPDIR="${D}/usr/$(get_libdir)/vamp" \
		INSTALL_LADSPADIR="${D}/usr/$(get_libdir)/ladspa" \
		INSTALL_LRDFDIR="${D}/usr/share/ladspa/rdf" \
		INSTALL_PKGDIR="${D}/usr/$(get_libdir)/pkgconfig" \
		install

	dodoc CHANGELOG README.txt
}
