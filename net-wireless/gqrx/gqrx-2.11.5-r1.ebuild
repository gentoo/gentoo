# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils

DESCRIPTION="Software defined radio receiver powered by GNU Radio and Qt"
HOMEPAGE="https://gqrx.dk/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/csete/gqrx.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/csete/gqrx/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="gr-audio portaudio pulseaudio"
REQUIRED_USE="^^ ( pulseaudio portaudio gr-audio )"

DEPEND=">=net-wireless/gnuradio-3.7_rc:=[audio,analog,filter]
	>=net-wireless/gr-osmosdr-0.1.0:=
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	pulseaudio? ( media-sound/pulseaudio:= )
	portaudio? ( media-libs/portaudio:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	if use !pulseaudio; then
		sed -i 's/AUDIO_BACKEND = pulse/#AUDIO_BACKEND = pulse/' gqrx.pro || die
	fi
	PATCHES=( "${FILESDIR}/gqrx-bladerf-samplerate.patch" )
	cmake-utils_src_prepare
	eapply_user
}

src_configure() {
	if use pulseaudio; then
		LINUX_AUDIO_BACKEND=Pulseaudio
	elif use portaudio; then
		LINUX_AUDIO_BACKEND=Portaudio
	elif use gr-audio; then
		LINUX_AUDIO_BACKEND=Gr-audio
	fi

	local mycmakeargs=(
		"-DLINUX_AUDIO_BACKEND=${LINUX_AUDIO_BACKEND}"
	)
	cmake-utils_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/src/gqrx
}
