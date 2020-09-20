# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
HOMEPAGE="https://www.breakfastquay.com/rubberband/"
SRC_URI="https://breakfastquay.com/files/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ladspa static-libs +programs vamp"

BDEPEND="
	virtual/pkgconfig
"
CDEPEND="
	media-libs/libsamplerate[${MULTILIB_USEDEP}]
	media-libs/libsndfile
	sci-libs/fftw:3.0[${MULTILIB_USEDEP}]
	ladspa? ( media-libs/ladspa-sdk )
	vamp? ( media-libs/vamp-plugin-sdk[${MULTILIB_USEDEP}] )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

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

multilib_src_configure() {
	econf WITH_PROGRAMS=$(usex programs) WITH_LADSPA=$(usex ladspa) WITH_VAMP=$(usex vamp)
}

multilib_src_compile() {
	emake WITH_PROGRAMS=$(usex programs) WITH_LADSPA=$(usex ladspa) WITH_VAMP=$(usex vamp)
}

multilib_src_install() {
	# fix libdir in .pc file
	sed -iE "s%/lib$%/$(get_libdir)%g" "${BUILD_DIR}/rubberband.pc.in" || die "Failed to fix .pc file"

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
