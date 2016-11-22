# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils eutils toolchain-funcs

DESCRIPTION="WYSIWYG score editor for GTK+"
HOMEPAGE="http://vsr.informatik.tu-chemnitz.de/staff/jan/nted/nted.xhtml"
SRC_URI="http://vsr.informatik.tu-chemnitz.de/staff/jan/${PN}/sources/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2 NTED_FONT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc debug nls"

RDEPEND="
	>=dev-libs/glib-2:2
	media-libs/alsa-lib
	>=media-libs/freetype-2.5.1
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/xmlto )
	nls? ( sys-devel/gettext )
"

DOCS=( ABOUT_THE_EXAMPLES.TXT AUTHORS FAQ README )

PATCHES=(
	"${FILESDIR}/${P}-gcc47.patch" # bug #424291
	"${FILESDIR}/${P}-lilypond.patch" # bug #437540
	"${FILESDIR}/${P}-lilypond-tremolo.patch" # bug #437540
	"${FILESDIR}/${P}-automake-1.12.patch" # bug #459466
	"${FILESDIR}/${P}-freetype.patch" # bug #514522
	"${FILESDIR}/${P}-cpp14.patch" # bug #594056
)

src_prepare() {
	# fix desktop file, wrt bug #458080
	sed -i \
		-e 's/nted.png/nted/' \
		-e '/^Categories/s/Application;//' \
		datafiles/applications/nted.desktop || die 'sed on desktop file failed'
	# drop -g from CXXFLAGS, wrt bug #458086
	sed -i -e '/CXXFLAGS/s/ -g//' configure.in || die 'sed on configure.in failed'

	autotools-utils_src_prepare
}

src_configure() {
	# Trick ./configure to believe we have gnome-extra/yelp installed.
	has_version gnome-extra/yelp || export ac_cv_path_YELP="$(type -P true)"

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable nls)
		$(use_with doc)
	)
	autotools-utils_src_configure
}

src_compile() {
	# respect AR, wrt bug #458084
	autotools-utils_src_compile AR="$(tc-getAR)"
}
