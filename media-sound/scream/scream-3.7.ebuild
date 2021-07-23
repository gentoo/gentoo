# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Plays sound received from network or from a QEMU Windows VM"
HOMEPAGE="https://github.com/duncanthrax/scream"
S="${WORKDIR}/${P}/Receivers/unix"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/duncanthrax/scream.git"
else
	SRC_URI="https://github.com/duncanthrax/scream/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Ms-PL"
SLOT="0"
IUSE="alsa jack pulseaudio"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	jack? (
		media-libs/soxr
		virtual/jack
	)
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DALSA_ENABLE=$(usex alsa)
		-DJACK_ENABLE=$(usex jack)
		-DPULSEAUDIO_ENABLE=$(usex pulseaudio)
	)
	cmake_src_configure
}
