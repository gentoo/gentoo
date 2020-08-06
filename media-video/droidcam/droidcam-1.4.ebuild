# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 desktop linux-mod xdg

DESCRIPTION="Turn your mobile device into a webcam"
HOMEPAGE="https://www.dev47apps.com/"
SRC_URI="https://github.com/aramg/droidcam/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="audio gtk usb"

DEPEND="=app-pda/libusbmuxd-1*
		dev-libs/glib
		gtk? ( dev-cpp/gtkmm:3.0 )
		media-libs/alsa-lib
		=media-libs/libjpeg-turbo-2*
		>=media-libs/speex-1.2.0-r1
		media-video/ffmpeg
		usb? ( dev-util/android-tools )
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/pango"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P}/linux"
DOCS=( README.md README-DKMS.md )
DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="
		The default resolution for v4l2loopback-dc[1] is 640x480. You can override the
		value by copying droidcam.conf.default to /etc/modprobe.d/droidcam.conf
		and modifying 'width' and 'height'.

		[1] https://github.com/aramg/droidcam/issues/56
"

BUILD_TARGETS="all"
MODULE_NAMES="v4l2loopback-dc(video:${S}/v4l2loopback:${S}/v4l2loopback)"
CONFIG_CHECK="MEDIA_SUPPORT MEDIA_CAMERA_SUPPORT"

PATCHES=(
		"${FILESDIR}"/${P}-Makefile-fixes.patch
)

src_configure() {
	if use audio ; then
		if linux_config_exists ; then
			if ! linux_chkconfig_present SND_ALOOP ; then
				die "Audio requested but CONFIG_SND_ALOOP not selected in config!"
			fi
		fi
	fi
	true
}

src_prepare() {
	if ! use gtk ; then
		sed -i -e '/cflags gtk+/d' Makefile
	else
		xdg_src_prepare
	fi
	linux-mod_pkg_setup
}

src_compile() {
	if use gtk ; then
		emake droidcam
	fi
	emake droidcam-cli
	KERNELRELEASE="${KV_FULL}" linux-mod_src_compile
}

pkg_preinst() {
	xdg_pkg_preinst
}

src_install() {
	if use gtk ; then
		dobin droidcam
		newicon -s 32 icon.png droidcam.png
		make_desktop_entry "${PN}" "DroidCam Client" "${PN}" AudioVideo
	fi
	dobin droidcam-cli
	readme.gentoo_create_doc
	insinto /etc/modules-load.d
	doins "${FILESDIR}"/${PN}-video.conf
	if use audio && linux_chkconfig_module SND_ALOOP ; then
		doins "${FILESDIR}"/${PN}-audio.conf
	fi
	newdoc "${FILESDIR}"/${PN}-modprobe.conf ${PN}.conf.default
	einstalldocs
	linux-mod_src_install
}

pkg_postinst() {
	if use gtk ; then
		xdg_pkg_postinst
	else
		elog
		elog "Only droidcam-cli has been installed since no 'gtk' flag was present"
		elog "in the USE list."
		elog
	fi
	linux-mod_pkg_postinst
	readme.gentoo_print_elog
	elog "Links to the Android/iPhone/iPad apps can be reached at"
	elog "https://www.dev47apps.com/"
}

pkg_postrm() {
	if use gtk ; then
		xdg_pkg_postrm
	fi
	linux-mod_pkg_postrm
}
