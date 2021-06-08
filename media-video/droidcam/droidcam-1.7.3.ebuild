# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop linux-mod xdg

DESCRIPTION="Use your phone or tablet as webcam with a v4l device driver and app"
HOMEPAGE="https://www.dev47apps.com/droidcam/linux/"
SRC_URI="https://github.com/dev47apps/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2"
SLOT="0"

IUSE="gtk"

# Requires connection to phone/tablet
RESTRICT="test"

DEPEND="
	app-pda/libplist
	app-pda/libusbmuxd
	dev-libs/glib
	dev-libs/libappindicator:3
	dev-libs/libxml2
	dev-util/android-tools
	media-libs/alsa-lib
	media-libs/libjpeg-turbo
	>=media-libs/speex-1.2.0-r1
	media-video/ffmpeg
	gtk? (
		dev-cpp/gtkmm:3.0
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/pango
	)
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

BUILD_TARGETS="all"
MODULE_NAMES="v4l2loopback-dc(video:${S}/v4l2loopback:${S}/v4l2loopback)"
MODULESD_V4L2LOOPBACK_DC_ENABLED="yes"

CONFIG_CHECK="~SND_ALOOP VIDEO_DEV MEDIA_SUPPORT MEDIA_CAMERA_SUPPORT"
ERROR_SND_ALOOP="CONFIG_SND_ALOOP is optionally required for audio support"

PATCHES="${FILESDIR}/${PN}-makefile-fixes.patch"

src_prepare() {
	if ! use gtk; then
		sed -i -e '/cflags gtk+/d' Makefile || die
		default
	else
		# remove path and extension from icon entry
		sed -i -e 's/Icon=\/opt\/droidcam-icon.png/Icon=droidcam/g' droidcam.desktop || die
		sed -i -e 's%/opt/droidcam-icon.png%/usr/share/icons/hicolor/96x96/apps/droidcam.png%g' src/droidcam.c || die
		xdg_src_prepare
	fi
}

src_configure() {
	set_arch_to_kernel
	default
}

src_compile() {
	if use gtk; then
		emake droidcam
	fi
	emake droidcam-cli
	KERNELRELEASE="${KV_FULL}" linux-mod_src_compile
}

src_test() {
	pushd "v4l2loopback"
	default
	./test || die
	popd
}

src_install() {
	if use gtk; then
		dobin droidcam
		newicon -s 32 icon.png droidcam.png
		newicon -s 96 icon2.png droidcam.png
		domenu droidcam.desktop
	fi
	dobin droidcam-cli

	# The cli and gui do not auto load the module if unloaded (why not though?)
	# so we just put it in modules-load.d to make sure it always works
	insinto /etc/modules-load.d
	if linux_config_exists; then
		if linux_chkconfig_module SND_ALOOP; then
			newins - "${PN}.conf" <<-EOF
				v4l2loopback-dc
				snd_aloop
			EOF
		else
			newins - "${PN}.conf" <<-EOF
				v4l2loopback-dc
			EOF
		fi
	fi

	einstalldocs
	linux-mod_src_install
}

pkg_preinst() {
	if use gtk; then
		xdg_pkg_preinst
	fi
	linux-mod_pkg_preinst
}

pkg_postinst() {
	linux-mod_pkg_postinst
	if use gtk; then
		xdg_pkg_postinst
	else
		elog
		elog "Only droidcam-cli has been installed since 'gtk' flag was not set"
		elog
	fi

	elog "The default resolution for v4l2loopback-dc (i.e. droidcam) is 640x480."
	elog "You can change this value in /etc/modprobe.d/v4l2loopback-dc.conf"
	elog
	elog "Links to the Android/iPhone/iPad apps can be found at"
	elog "https://www.dev47apps.com/"
}

pkg_postrm() {
	if use gtk; then
		xdg_pkg_postrm
	fi
	linux-mod_pkg_postrm
}
