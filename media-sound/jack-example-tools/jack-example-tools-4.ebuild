# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Official examples and tools from the JACK project"
HOMEPAGE="https://jackaudio.org/"
SRC_URI="https://github.com/jackaudio/jack-example-tools/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ zalsa? ( GPL-3+ )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="alsa jack-net jack-netsource opus +readline sndfile zalsa"

RDEPEND="
	virtual/jack
	alsa? (
		media-libs/alsa-lib
		media-libs/libsamplerate
	)
	jack-net? (
		|| (
			media-sound/jack2[libsamplerate]
			media-video/pipewire[jack-sdk(-)]
		)
	)
	jack-netsource? (
		media-libs/libsamplerate
		opus? ( media-libs/opus[custom-modes] )
	)
	readline? ( sys-libs/readline:= )
	sndfile? ( media-libs/libsndfile )
	zalsa? (
		media-libs/alsa-lib
		media-libs/zita-alsa-pcmi
		media-libs/zita-resampler:=
	)
	!<media-sound/jack-audio-connection-kit-0.126.0
	!<media-sound/jack2-1.9.21"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md README.md )

src_configure() {
	local emesonargs=(
		$(meson_feature alsa alsa_in_out)
		$(meson_feature jack{-,_}net)
		$(meson_feature jack{-,_}netsource)
		$(meson_feature readline readline_support)
		$(meson_feature sndfile jack_rec)
		$(meson_feature zalsa)
		$(usex jack-netsource \
			$(meson_feature opus opus_support) \
			-Dopus_support=disabled)
	)

	meson_src_configure
}
