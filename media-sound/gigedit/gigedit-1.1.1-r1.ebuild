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
	dev-cpp/gtkmm:2.4
	>=media-libs/libgig-3.3.0
	>=media-libs/libsndfile-1.0.2
	>=media-sound/linuxsampler-0.5.1"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

src_prepare() {
	default
	# docdir is not propagated there
	sed -i '/docdir/d' doc/quickstart/Makefile.am || die
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
