# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic xdg subversion

DESCRIPTION="An instrument editor for gig files"
HOMEPAGE="http://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/gigedit/trunk"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-cpp/gtkmm:2.4
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
