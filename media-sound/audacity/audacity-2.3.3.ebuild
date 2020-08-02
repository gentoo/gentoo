# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"

inherit flag-o-matic wxwidgets xdg

MY_P="Audacity-${PV}"
DOC_PV="${PV}"
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="https://web.audacityteam.org/"
# wget doesn't seem to work on FossHub links, so we mirror
SRC_URI="https://github.com/audacity/audacity/archive/${MY_P}.tar.gz
	doc? ( https://dev.gentoo.org/~polynomial-c/dist/${PN}-manual-${DOC_PV}.zip )"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="alsa cpu_flags_x86_sse doc ffmpeg +flac id3tag jack +ladspa +lame
	+lv2 mad midi nls +portmixer sbsms +soundtouch twolame vamp +vorbis +vst"

RESTRICT="test"

RDEPEND="dev-libs/expat
	>=media-libs/libsndfile-1.0.0
	>=media-libs/portaudio-19.06.00-r2[alsa?]
	<media-libs/portaudio-20
	media-libs/soxr
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( >=media-video/ffmpeg-1.2:= )
	flac? ( >=media-libs/flac-1.3.1[cxx] )
	id3tag? ( media-libs/libid3tag )
	jack? ( virtual/jack )
	lame? ( >=media-sound/lame-3.70 )
	lv2? (
		media-libs/lilv
		media-libs/lv2
		media-libs/suil
	)
	mad? ( >=media-libs/libmad-0.14.2b )
	sbsms? ( media-libs/libsbsms )
	soundtouch? ( >=media-libs/libsoundtouch-1.3.1 )
	twolame? ( media-sound/twolame )
	vamp? ( >=media-libs/vamp-plugin-sdk-2.0 )
	vorbis? ( >=media-libs/libvorbis-1.0 )
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.3-Fix-building-against-system-portaudio.patch
	"${FILESDIR}"/${PN}-2.3.3-fno-common.patch
)

src_prepare() {
	default

	use midi || sed -i \
		-e 's:^\(#define EXPERIMENTAL_MIDI_OUT\):// \1:' \
		src/Experimental.h || die
}

src_configure() {
	setup-wxwidgets
	append-cxxflags -std=gnu++14

	# * always use system libraries if possible
	# * options listed in the order that configure --help lists them
	local myeconfargs=(
		--disable-dynamic-loading
		--enable-nyquist=local
		--enable-unicode
		--with-expat
		--with-lib-preference=system
		--with-libsndfile
		--with-libsoxr
		--with-mod-script-pipe
		--with-mod-nyq-bench
		--with-portaudio
		--with-widgetextra=local
		--with-wx-version=${WX_GTK_VER}
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable ladspa)
		$(use_enable nls)
		$(use_enable vst)
		$(use_with ffmpeg)
		$(use_with flac libflac)
		$(use_with id3tag libid3tag)
		$(use_with lame)
		$(use_with lv2)
		$(use_with mad libmad)
		$(use_with midi portmidi local)
		$(use_with midi "" local)
		$(use_with portmixer)
		$(use_with sbsms)
		$(use_with soundtouch)
		$(use_with twolame libtwolame)
		$(use_with vamp libvamp)
		$(use_with vorbis libvorbis)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	# Remove bad doc install
	rm -r "${ED}"/usr/share/doc || die

	# Install our docs
	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r "${WORKDIR}"/manual/{m,man,manual}
		dodoc "${WORKDIR}"/manual/{favicon.ico,index.html,quick_help.html}
		dosym ../../doc/${PF}/html /usr/share/${PN}/help/manual
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
