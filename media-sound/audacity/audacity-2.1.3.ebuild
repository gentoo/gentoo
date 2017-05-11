# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils wxwidgets

MY_P="${PN}-minsrc-${PV}"
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="http://web.audacityteam.org/"
SRC_URI="https://dev.gentoo.org/~polynomial-c/dist/${MY_P}.tar.xz
	doc? ( https://dev.gentoo.org/~polynomial-c/dist/${PN}-help-${PV}.zip )"
	# wget doesn't seem to work on FossHub links, so we mirror

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~x86"
IUSE="alsa cpu_flags_x86_sse doc ffmpeg +flac id3tag jack +ladspa +lame libav
	+lv2 mad +midi nls +portmixer sbsms +soundtouch twolame vamp +vorbis +vst"
RESTRICT="test"

RDEPEND=">=app-arch/zip-2.3
	dev-libs/expat
	>=media-libs/libsndfile-1.0.0
	=media-libs/portaudio-19*
	media-libs/soxr
	x11-libs/wxGTK:3.0[X]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( libav? ( media-video/libav:= )
		!libav? ( >=media-video/ffmpeg-1.2:= ) )
	flac? ( >=media-libs/flac-1.2.0[cxx] )
	id3tag? ( media-libs/libid3tag )
	jack? ( >=media-sound/jack-audio-connection-kit-0.103.0 )
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
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

REQUIRED_USE="soundtouch? ( midi )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	WX_GTK_VER="3.0"
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
	rm -r "${D}"/usr/share/doc || die

	# Install our docs
	dodoc README.txt

	if use doc ; then
		docinto html
		dodoc -r "${WORKDIR}"/{m,man,manual}
		dodoc "${WORKDIR}"/{favicon.ico,index.html,quick_help.html}
	fi
}
