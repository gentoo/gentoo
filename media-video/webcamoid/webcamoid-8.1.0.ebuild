# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ca de el es et fr gl it ja kab ko nl pt ru uk zh_CN zh_TW"

inherit l10n qmake-utils

DESCRIPTION="A full featured webcam capture application"
HOMEPAGE="https://webcamoid.github.io"
SRC_URI="https://github.com/webcamoid/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

IUSE_AVKYS=( alsa coreaudio ffmpeg gstreamer jack libuvc oss pulseaudio qtaudio v4lutils videoeffects )
IUSE="${IUSE_AVKYS[@]} debug headers libav v4l"

REQUIRED_USE="
	libav? ( ffmpeg )
	v4lutils? ( v4l )
"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:= )
	)
	gstreamer? ( >=media-libs/gstreamer-1.6.0 )
	jack? ( virtual/jack )
	libuvc? ( media-libs/libuvc )
	pulseaudio? ( media-sound/pulseaudio )
	qtaudio? ( dev-qt/qtmultimedia:5 )
	v4l? ( media-libs/libv4l )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	>=sys-kernel/linux-headers-3.6
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-ffmpeg-4.patch" )

src_prepare() {
	local tsdir="${S}/StandAlone/share/ts"
	local mylrelease="$(qt5_get_bindir)"/lrelease

	prepare_locale() {
		"${mylrelease}" "${tsdir}/${1}.ts" || die "preparing ${1} locale failed"
	}

	rm_locale() {
		sed -i \
			-e '/.*share\/ts\/'${1}'\.qm.*/d' \
			StandAlone/translations.qrc || die
	}

	rm ${tsdir}/*.qm

	l10n_find_plocales_changes "${tsdir}" "" '.ts'
	l10n_for_each_locale_do prepare_locale
	l10n_for_each_disabled_locale_do rm_locale

	default
}

src_configure() {
	local myqmakeargs=(
		"CONFIG+=debug"
		"PREFIX=/usr"
		"BUILDDOCS=0"
		"INSTALLDEVHEADERS=$(usex headers 1 0)"
		"LIBDIR=/usr/$(get_libdir)"
		"NOAVFOUNDATION=1"
		"NODSHOW=1"
		"NOVCAMWIN=1"
		"NOWASAPI=1"
	)

	use v4l || myqmakeargs+=( "NOV4L2=1" )

	for x in ${IUSE_AVKYS[@]}; do
		use ${x} || myqmakeargs+=( "NO${x^^}=1" )
	done

	eqmake5 ${myqmakeargs[@]}
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
