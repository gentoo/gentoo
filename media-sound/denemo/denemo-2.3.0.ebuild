# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools xdg

DESCRIPTION="A music notation editor"
HOMEPAGE="http://www.denemo.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# configure options currently not used:
# --enable-mem(no) memory debugging: needs Electric fence (efence), which
#		is not available in portage. See https://github.com/boundarydevices/efence
# --enable-gtk-doc-pdf(no) doesn't work
IUSE="alsa +aubio debug +evince jack +fluidsynth gtk-doc +gtk3 nls +portaudio
	+portmidi +rubberband static test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2:2
	>=dev-scheme/guile-2:12=
	gnome-base/librsvg:2
	media-libs/fontconfig:1.0
	>=media-libs/libsmf-1.3
	>=media-libs/libsndfile-1.0.28-r1
	>=media-sound/lilypond-2.19.54[guile2]
	alsa? ( >=media-libs/alsa-lib-1.1.2 )
	aubio? ( >=media-libs/aubio-0.4.1-r1:= )
	evince? ( >=app-text/evince-3.22.1-r1:= )
	fluidsynth? ( >=media-sound/fluidsynth-1.1.6-r1:= )
	gtk3? (
		x11-libs/gtk+:3
		x11-libs/gtksourceview:3.0=
	)
	!gtk3? (
		x11-libs/gtk+:2
		x11-libs/gtksourceview:2.0
	)
	jack? ( virtual/jack )
	portaudio? (
		>=media-libs/portaudio-19_pre20140130
		sci-libs/fftw:3.0=
	)
	portmidi? ( >=media-libs/portmidi-217-r1 )
	rubberband? ( >=media-libs/rubberband-1.8.1-r1 )
"

DEPEND="${RDEPEND}"

BDEPEND="
	>=dev-util/intltool-0.51.0-r1
	>=sys-devel/flex-2.6.1
	virtual/pkgconfig
	virtual/yacc
	gtk-doc? (
		>=dev-util/gtk-doc-1.25-r1
		>=dev-util/gtk-doc-am-1.25-r1
	)
	nls? ( >=sys-devel/gettext-0.19.8.1 )
"

REQUIRED_USE="
	evince? ( gtk3 )
"

DOCS=( AUTHORS ChangeLog docs/{DESIGN{,.lilypond},GOALS,TODO} NEWS )

PATCHES=(
	"${FILESDIR}/${P}-0001-configure.ac-patch-to-find-guile-2.2.patch"
)

src_prepare() {
	sed -e '/^Categories=/s/GNOME\;/GNOME\;GTK\;/' -i pixmaps/denemo.desktop || die
	default
	eautoreconf
}

src_configure() {
	myeconfargs=(
		--disable-gtk-doc-pdf
		--disable-installed-tests
		--disable-mem
		--disable-rpath
		--enable-x11
		$(use_enable alsa)
		$(use_enable aubio)
		# --enable-doc does nothing for itself
		# basic html documentation is always being installed in the
		# /usr/share/denemo/manual directory
		$(use_enable gtk-doc doc)
		$(use_enable gtk-doc gtk-doc)
		$(use_enable gtk-doc gtk-doc-html)
		$(use_enable evince)
		$(use_enable fluidsynth)
		$(use_enable jack)
		$(use_enable nls)
		$(use_enable portaudio)
		$(use_enable portmidi)
		$(use_enable rubberband)
		$(use_enable static)
		$(usex gtk3 --enable-gtk3 --enable-gtk2)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	# make check fails if used with parallel builds
	emake -j1 check
}

src_install() {
	default

	# link html documentation installed in /usr/share/denemo/manual
	dodir /usr/share/doc/${PF}/html
	local f
	for f in denemo-manual.html denemo.css images; do
		dosym ../../../denemo/manual/"${f}" /usr/share/doc/${PF}/html/"${f}"
	done
}
