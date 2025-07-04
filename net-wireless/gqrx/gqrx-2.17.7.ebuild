# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Software defined radio receiver powered by GNU Radio and Qt"
HOMEPAGE="https://gqrx.dk/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/gqrx-sdr/gqrx.git"
	inherit git-r3
else
	SRC_URI="https://github.com/gqrx-sdr/gqrx/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="portaudio pulseaudio"
REQUIRED_USE="?? ( pulseaudio portaudio )"

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtsvg:6
	>=net-wireless/gnuradio-3.10:0=[audio,analog,filter,network]
	>=net-wireless/gr-osmosdr-0.1.0:=
	sci-libs/volk:=
	pulseaudio? ( media-libs/libpulse )
	portaudio? ( media-libs/portaudio:= )"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-libs/log4cpp
"

src_configure() {
	if use pulseaudio; then
		LINUX_AUDIO_BACKEND=Pulseaudio
	elif use portaudio; then
		LINUX_AUDIO_BACKEND=Portaudio
	else
		LINUX_AUDIO_BACKEND=Gr-audio
	fi

	local mycmakeargs=(
		-DFORCE_QT6=ON
		-DFORCE_QT5=OFF
		-DLINUX_AUDIO_BACKEND="${LINUX_AUDIO_BACKEND}"
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/src/gqrx
}
