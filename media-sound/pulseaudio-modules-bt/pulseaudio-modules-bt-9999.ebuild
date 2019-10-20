# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils readme.gentoo-r1

DESCRIPTION="PulseAudio modules for LDAC, aptX, aptX HD, and AAC for Bluetooth (alongside SBC and native+ofono headset)"
HOMEPAGE="https://github.com/EHfive/pulseaudio-modules-bt"
SRC_URI=""
EGIT_REPO_URI="https://github.com/EHfive/${PN}"

# Ensure it is synced with major pulseaudio version
# https://github.com/EHfive/pulseaudio-modules-bt/issues/83
EGIT_OVERRIDE_COMMIT_PULSEAUDIO_PULSEAUDIO="v13.0"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-libs/fdk-aac:0=
	virtual/ffmpeg
	media-libs/sbc
	media-libs/libldac
	>=net-wireless/bluez-5
	>=sys-apps/dbus-1.0.0
	>=net-misc/ofono-1.13
	>=media-sound/pulseaudio-13[-bluetooth]
"
# Ordinarily media-libs/libldac should be in DEPEND too, but for now upstream repo is using a ldac submodule instead.

RDEPEND="${DEPEND}"
BDEPEND=""

CMAKE_MAKEFILE_GENERATOR="emake"

DISABLE_AUTOFORMATTING="no"
DOC_CONTENTS="
After getting media-sound/pulseaudio merged without its bluetooth
support (to not collide with this) you may have removed the loading
of bluetooth modules in default.pa config file, leading to failure
to use your bluetooth device (see
https://github.com/EHfive/pulseaudio-modules-bt/issues/33).
Please ensure you have this lines present in your /etc/pulse/default.pa
file:

.ifexists module-bluetooth-policy.so
load-module module-bluetooth-policy
.endif

.ifexists module-bluetooth-discover.so
load-module module-bluetooth-discover
.endif
"

src_install() {
	cmake-utils_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
