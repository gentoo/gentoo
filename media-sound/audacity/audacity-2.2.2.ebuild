# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils wxwidgets xdg-utils

MY_P="${PN}-minsrc-${PV}"
DOC_PV="${PV}"
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="https://web.audacityteam.org/"
SRC_URI="https://dev.gentoo.org/~polynomial-c/dist/${MY_P}.tar.xz
	doc? ( https://dev.gentoo.org/~polynomial-c/dist/${PN}-manual-${DOC_PV}.zip )"
	# wget doesn't seem to work on FossHub links, so we mirror

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86"
IUSE="alsa cpu_flags_x86_sse doc ffmpeg +flac id3tag jack +ladspa +lame
	+lv2 mad +midi nls +portmixer sbsms +soundtouch twolame vamp +vorbis +vst"

RESTRICT="test"

RDEPEND=">=app-arch/zip-2.3
	dev-libs/expat
	>=media-libs/libsndfile-1.0.0
	>=media-libs/portaudio-19_pre
	<media-libs/portaudio-19.06.00-r2
	media-libs/soxr
	x11-libs/wxGTK:3.0[X]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( >=media-video/ffmpeg-1.2:= )
	flac? ( >=media-libs/flac-1.3.1[cxx] )
	id3tag? ( media-libs/libid3tag )
	jack? ( virtual/jack )
	lame? ( >=media-sound/lame-3.70 )
	lv2? ( media-libs/lv2 )
	mad? ( >=media-libs/libmad-0.14.2b )
	midi? ( media-libs/portmidi )
	sbsms? ( media-libs/libsbsms )
	soundtouch? ( >=media-libs/libsoundtouch-1.3.1 )
	twolame? ( media-sound/twolame )
	vamp? ( >=media-libs/vamp-plugin-sdk-2.0 )
	vorbis? ( >=media-libs/libvorbis-1.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

REQUIRED_USE="soundtouch? ( midi )"

S="${WORKDIR}/${MY_P}-rc1"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.1-portmixer.patch" #624264
	"${FILESDIR}/${PN}-2.2.2-automake.patch" # or else eautoreconf breaks
	"${FILESDIR}/${PN}-2.2.2-midi.patch" #637110
)

src_prepare() {
	default
	# needed because of portmixer patch
	eautoreconf
}

src_configure() {
	local WX_GTK_VER="3.0"
	need-wxwidgets unicode

	# * always use system libraries if possible
	# * options listed in the order that configure --help lists them
	local myeconfargs=(
		--disable-dynamic-loading
		--enable-nyquist
		--enable-unicode
		--with-expat=system
		--with-libsndfile=system
		--with-libsoxr=system
		--with-portaudio
		--with-widgetextra=local
		--with-wx-version=${WX_GTK_VER}
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable ladspa)
		$(use_enable nls)
		$(use_enable vst)
		#$(use_with alsa)
		$(use_with ffmpeg)
		$(use_with flac libflac)
		$(use_with id3tag libid3tag)
		#$(use_with jack)
		$(use_with lame)
		$(use_with lv2)
		$(use_with mad libmad)
		$(use_with midi)
		$(use_with sbsms)
		$(use_with soundtouch)
		$(use_with twolame libtwolame)
		$(use_with vamp libvamp)
		$(use_with vorbis libvorbis)
		$(use_with portmixer)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	# Remove bad doc install
	rm -r "${D%/}"/usr/share/doc || die

	# Install our docs
	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r "${WORKDIR}"/help/manual/{m,man,manual}
		dodoc "${WORKDIR}"/help/manual/{favicon.ico,index.html,quick_help.html}
		dosym ../../doc/${PF}/html /usr/share/${PN}/help/manual
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
