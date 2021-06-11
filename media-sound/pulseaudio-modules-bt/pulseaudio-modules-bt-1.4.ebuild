# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake readme.gentoo-r1

DESCRIPTION="PulseAudio modules for LDAC, aptX, aptX HD, and AAC for Bluetooth"
HOMEPAGE="https://github.com/EHfive/pulseaudio-modules-bt"

PULSE_VER="13.0"
SRC_URI="
	https://github.com/EHfive/pulseaudio-modules-bt/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://freedesktop.org/software/pulseaudio/releases/pulseaudio-${PULSE_VER}.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fdk +ffmpeg +ldac +native-headset ofono-headset"

DEPEND="
	fdk? ( media-libs/fdk-aac:0= )
	ffmpeg? ( media-video/ffmpeg )
	media-libs/sbc
	ldac? ( media-libs/libldac )
	>=net-wireless/bluez-5
	>=sys-apps/dbus-1.0.0
	ofono-headset? ( >=net-misc/ofono-1.13 )
	>=media-sound/pulseaudio-${PULSE_VER}[-bluetooth]
"
# Ordinarily media-libs/libldac should be in DEPEND too, but for now upstream repo is using a ldac submodule instead.
RDEPEND="${DEPEND}"
BDEPEND=""

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

src_prepare() {
	cmake_src_prepare

	# pulseaudio headers needed to build
	rmdir pa/ || die
	ln -s ../pulseaudio-${PULSE_VER}/ pa || die
}

src_configure() {
	local mycmakeargs=(
		-DCODEC_AAC_FDK=$(usex fdk "ON" "OFF")
		-DCODEC_APTX_FF=$(usex ffmpeg "ON" "OFF")
		-DCODEC_APTX_HD_FF=$(usex ffmpeg "ON" "OFF")
		-DCODEC_LDAC=$(usex ldac "ON" "OFF")
		-DNATIVE_HEADSET=$(usex native-headset "ON" "OFF")
		-DOFONO_HEADSET=$(usex ofono-headset "ON" "OFF")
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
