# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib multilib-minimal

DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
HOMEPAGE="http://www.breakfastquay.com/rubberband/"
SRC_URI="http://code.breakfastquay.com/attachments/download/34/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="static-libs"

RDEPEND="media-libs/vamp-plugin-sdk[${MULTILIB_USEDEP}]
	media-libs/libsamplerate[${MULTILIB_USEDEP}]
	media-libs/libsndfile
	media-libs/ladspa-sdk
	sci-libs/fftw:3.0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if ! use static-libs ; then
		sed -e '/^all:/s/$(STATIC_TARGET)//' \
			-e '/^\tcp $(STATIC_TARGET)/d' \
			-i Makefile.in || die
	fi
	multilib_copy_sources
}

multilib_src_install() {
	emake INSTALL_BINDIR="${D}/usr/bin" \
		INSTALL_INCDIR="${D}/usr/include/rubberband" \
		INSTALL_LIBDIR="${D}/usr/$(get_libdir)" \
		INSTALL_VAMPDIR="${D}/usr/$(get_libdir)/vamp" \
		INSTALL_LADSPADIR="${D}/usr/$(get_libdir)/ladspa" \
		INSTALL_LRDFDIR="${D}/usr/share/ladspa/rdf" \
		INSTALL_PKGDIR="${D}/usr/$(get_libdir)/pkgconfig" \
		install
}

multilib_src_install_all() {
	dodoc CHANGELOG README.txt
}
