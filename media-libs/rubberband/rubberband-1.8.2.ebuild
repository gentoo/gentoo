# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
HOMEPAGE="https://www.breakfastquay.com/rubberband/"
SRC_URI="https://breakfastquay.com/files/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~sparc x86"
IUSE="static-libs"

RDEPEND="
	media-libs/ladspa-sdk
	media-libs/libsamplerate[${MULTILIB_USEDEP}]
	media-libs/libsndfile
	media-libs/vamp-plugin-sdk[${MULTILIB_USEDEP}]
	sci-libs/fftw:3.0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	if ! use static-libs ; then
		sed -e '/^all:/s/$(STATIC_TARGET)//' \
			-e '/^\tcp $(STATIC_TARGET)/d' \
			-i Makefile.in || die
	fi

	sed -e '/cp -f.*JNI_TARGET/d' -i Makefile.in || die

	multilib_copy_sources
}

multilib_src_install() {
	emake INSTALL_BINDIR="${ED}/usr/bin" \
		INSTALL_INCDIR="${ED}/usr/include/rubberband" \
		INSTALL_LIBDIR="${ED}/usr/$(get_libdir)" \
		INSTALL_VAMPDIR="${ED}/usr/$(get_libdir)/vamp" \
		INSTALL_LADSPADIR="${ED}/usr/$(get_libdir)/ladspa" \
		INSTALL_LRDFDIR="${ED}/usr/share/ladspa/rdf" \
		INSTALL_PKGDIR="${ED}/usr/$(get_libdir)/pkgconfig" \
		install
}

multilib_src_install_all() {
	einstalldocs
}
