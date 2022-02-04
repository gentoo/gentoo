# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic xdg

DESCRIPTION="An instrument editor for gig files"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-cpp/gtkmm:3.0
	media-libs/libgig
	media-libs/libsndfile
	media-sound/linuxsampler"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	default
	# docdir is not propagated there
	sed -i '/docdir/d' doc/quickstart/Makefile.am || die
	# file missing in pot file
	echo src/gigedit/ScriptPatchVars.cpp >> "po/POTFILES.in" || die
	eautoreconf
}

src_configure() {
	append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/linuxsampler"
	econf --disable-static
}

src_install() {
	default
	make_desktop_entry gigedit GigEdit "" "AudioVideo;AudioVideoEditing"

	find "${ED}" -name '*.la' -delete || die
}
