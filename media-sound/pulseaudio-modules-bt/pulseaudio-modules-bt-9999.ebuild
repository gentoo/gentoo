# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="PulseAudio modules for LDAC, aptX, aptX HD, and AAC for Bluetooth (alongside SBC and native+ofono headset)"
HOMEPAGE="https://github.com/EHfive/pulseaudio-modules-bt"
SRC_URI=""
EGIT_REPO_URI="https://github.com/EHfive/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-libs/fdk-aac
	virtual/ffmpeg
	media-libs/sbc
	>=net-wireless/bluez-5
	>=sys-apps/dbus-1.0.0
	>=net-misc/ofono-1.13
	media-sound/pulseaudio[-bluetooth]
"
# Ordinarily media-libs/libldac should be in DEPEND too, but for now upstream repo is using a ldac submodule instead.

RDEPEND="${DEPEND}"
BDEPEND=""

CMAKE_MAKEFILE_GENERATOR="emake"
