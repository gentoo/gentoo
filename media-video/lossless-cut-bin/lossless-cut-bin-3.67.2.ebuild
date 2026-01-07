# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils

DESCRIPTION="The swiss army knife of lossless video/audio editing"
HOMEPAGE="
	https://mifi.no/losslesscut/
	https://github.com/mifi/lossless-cut
"
SRC_URI="
	amd64? ( https://github.com/mifi/lossless-cut/releases/download/v${PV}/LosslessCut-linux-x64.tar.bz2 -> lossless-cut-amd64-${PV}.tar.bz2 )
	arm64? ( https://github.com/mifi/lossless-cut/releases/download/v${PV}/LosslessCut-linux-arm64.tar.bz2 -> lossless-cut-arm64-${PV}.tar.bz2 )
	arm? ( https://github.com/mifi/lossless-cut/releases/download/v${PV}/LosslessCut-linux-armv7l.tar.bz2 -> lossless-cut-arm-${PV}.tar.bz2 )
"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+system-ffmpeg"
RESTRICT="splitdebug"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[X(+)]
	net-print/cups
	sys-apps/dbus
	virtual/udev
	x11-libs/cairo
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
	system-ffmpeg? ( media-video/ffmpeg )
"
BDEPEND="!system-ffmpeg? ( app-admin/chrpath )"
QA_PREBUILT="
	opt/LosslessCut/chrome_crashpad_handler
	opt/LosslessCut/chrome-sandbox
	opt/LosslessCut/libEGL.so
	opt/LosslessCut/libGLESv2.so
	opt/LosslessCut/libffmpeg.so
	opt/LosslessCut/libvk_swiftshader.so
	opt/LosslessCut/libvulkan.so.1
	opt/LosslessCut/resources/ffmpeg
	opt/LosslessCut/resources/ffprobe
	opt/LosslessCut/resources/*.so*
	opt/LosslessCut/losslesscut
"

src_install() {
	insinto /opt/LosslessCut
	doins -r */*

	fperms +x /opt/LosslessCut/{losslesscut,chrome-sandbox,chrome_crashpad_handler}
	pax-mark m opt/LosslessCut/{losslesscut,chrome-sandbox,chrome_crashpad_handler}

	if use system-ffmpeg; then
		rm "${D}"/opt/LosslessCut/resources/{ffmpeg,ffprobe} || die
		ln -s -t "${D}"/opt/LosslessCut/resources "${EPREFIX}"/usr/bin/{ffmpeg,ffprobe} || die
	else
		fperms +x /opt/LosslessCut/resources/{ffmpeg,ffprobe}
		pax-mark m opt/LosslessCut/resources/{ffmpeg,ffprobe}
		chrpath -d "${D}"/opt/LosslessCut/resources/{ffmpeg,ffprobe} || die
	fi

	dosym ../../opt/LosslessCut/losslesscut "${EPREFIX}"/usr/bin/losslesscut
}
