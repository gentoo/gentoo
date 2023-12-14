# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"

inherit cmake flag-o-matic wxwidgets xdg

MY_P="Audacity-${PV}"
DOC_PV="${PV}"
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="https://www.audacityteam.org/"
# wget doesn't seem to work on FossHub links, so we mirror
SRC_URI="https://github.com/audacity/audacity/archive/${MY_P}.tar.gz
	doc? ( https://dev.gentoo.org/~fordfrog/distfiles/${PN}-manual-${DOC_PV}.zip )"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv x86"
IUSE="alsa doc ffmpeg +flac id3tag jack +ladspa +lv2 mad ogg oss
	portmidi +portmixer portsmf sbsms twolame vamp +vorbis +vst"

RESTRICT="test"

RDEPEND="dev-libs/expat
	media-libs/libsndfile
	media-libs/libsoundtouch:=
	media-libs/portaudio[alsa?]
	media-libs/soxr
	>=media-sound/lame-3.100-r3
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:=[cxx] )
	id3tag? ( media-libs/libid3tag:= )
	jack? ( virtual/jack )
	lv2? (
		dev-libs/serd
		dev-libs/sord
		>=media-libs/lilv-0.24.6-r2
		media-libs/lv2
		media-libs/sratom
		media-libs/suil
	)
	mad? ( >=media-libs/libmad-0.15.1b )
	ogg? ( media-libs/libogg )
	portmidi? ( media-libs/portmidi )
	sbsms? ( media-libs/libsbsms )
	twolame? ( media-sound/twolame )
	vamp? ( media-libs/vamp-plugin-sdk )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	sys-devel/gettext
	virtual/pkgconfig
"

REQUIRED_USE="portmidi? ( portsmf )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.3-Fix-building-against-system-portaudio.patch
	"${FILESDIR}/${P}-fix-vertical-track-resizing.patch"
	"${FILESDIR}/${P}-fix-gettimeofday.patch"
	"${FILESDIR}/${P}-fix-metainfo.patch"
	"${FILESDIR}/${P}-add-missing-include-portaudio.patch"
	"${FILESDIR}/${P}-disable-ccache.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	setup-wxwidgets
	append-cxxflags -std=gnu++14

	# * always use system libraries if possible
	# * options listed in the order that cmake-gui lists them
	local mycmakeargs=(
#		--disable-dynamic-loading
		-Daudacity_lib_preference=system
		-Daudacity_use_expat=system
		-Daudacity_use_ffmpeg=$(usex ffmpeg loaded off)
		-Daudacity_use_flac=$(usex flac system off)
		-Daudacity_use_id3tag=$(usex id3tag system off)
		-Daudacity_use_ladspa=$(usex ladspa)
		-Daudacity_use_lame=system
		-Daudacity_use_lv2=$(usex lv2 system off)
		-Daudacity_use_mad=$(usex mad system off)
		-Daudacity_use_midi=$(usex portmidi system off)
		-Daudacity_use_nyquist=local
		-Daudacity_use_ogg=$(usex ogg system off)
		-Daudacity_use_pa_alsa=$(usex alsa)
		-Daudacity_use_pa_jack=$(usex jack linked off)
		-Daudacity_use_pa_oss=$(usex oss)
		#-Daudacity_use_pch leaving it to the default behavior
		-Daudacity_use_portaudio=local # only 'local' option is present
		-Daudacity_use_portmixer=$(usex portmixer local off)
		-Daudacity_use_portsmf=$(usex portsmf local off)
		-Daudacity_use_sbsms=$(usex sbsms local off) # no 'system' option in configuration?
		-Daudacity_use_sndfile=system
		-Daudacity_use_soundtouch=system
		-Daudacity_use_soxr=system
		-Daudacity_use_twolame=$(usex twolame system off)
		-Daudacity_use_vamp=$(usex vamp system off)
		-Daudacity_use_vorbis=$(usex vorbis system off)
		-Daudacity_use_vst=$(usex vst)
		-Daudacity_use_wxwidgets=system
	)

	cmake_src_configure

	# if git is not installed, this (empty) file is not being created and the compilation fails
	# so we create it manually
	touch "${BUILD_DIR}/src/private/RevisionIdent.h" || die "failed to create file"
}

src_install() {
	cmake_src_install

	# Remove bad doc install
	rm -r "${ED}"/usr/share/doc || die

	if use doc ; then
		docinto html
		dodoc -r "${WORKDIR}"/help/manual/{m,man,manual}
		dodoc "${WORKDIR}"/help/manual/{favicon.ico,index.html,quick_help.html}
		dosym ../../doc/${PF}/html /usr/share/${PN}/help/manual
	fi
}
