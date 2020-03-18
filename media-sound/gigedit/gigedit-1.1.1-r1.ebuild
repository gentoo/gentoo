# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools eutils desktop xdg

DESCRIPTION="An instrument editor for gig files"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

BDEPEND="
	sys-devel/gettext
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"
CDEPEND="
	dev-cpp/gtkmm:2.4
	>=media-libs/libgig-3.3.0
	>=media-libs/libsndfile-1.0.2
	>=media-sound/linuxsampler-0.5.1
"
DEPEND="${RDEPEND}"
RDEPEND="${CDEPEND}"

src_prepare() {
	default

	# docdir is not propagated there
	sed -i "s%\$(datadir)/doc/\$(PACKAGE)%\$(datadir)/doc/${P}%g" doc/quickstart/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_compile() {
	emake LDFLAGS="${LDFLAGS} -Wl,-rpath,/usr/$(get_libdir)/linuxsampler"
}

src_install() {
	default

	einfo "Removing static libs..."
	find "${D}" -name "*.la" -delete || die "Failed to remove static libs"

	make_desktop_entry gigedit GigEdit "" "AudioVideo;AudioVideoEditing"
}
