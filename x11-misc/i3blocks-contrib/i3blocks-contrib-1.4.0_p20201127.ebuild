# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit optfeature vcs-snapshot

COMMIT=154001e5713c26c70063446022919225b6f916f0

DESCRIPTION="A set of scripts for i3blocks, contributed by the community"
HOMEPAGE="https://github.com/vivien/i3blocks-contrib"
SRC_URI="https://github.com/vivien/i3blocks-contrib/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND=""
RDEPEND="!<x11-misc/i3blocks-1.5
	>=x11-misc/i3blocks-1.5"
BDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-respect-CFLAGS.patch )

src_prepare() {
	sed -i -e '/^$(_BLOCKS):/ s/$/ installdirs/' Makefile
	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}

pkg_postinst() {
	optfeature_header "The following deps may be required for certain ${PN} scripts:"
	optfeature "backlight" sys-power/acpilight x11-apps/xbacklight
	optfeature "battery{,2,bar}" sys-power/acpi
	optfeature "cpu_usage" app-admin/sysstat
	optfeature "disk-io" app-admin/sysstat
	optfeature "email" dev-python/keyring gnome-base/gnome-keyring
	optfeature "gpu-load" x11-drivers/nvidia-drivers app-misc/radeontop
	optfeature "kbdd_layout" x11-misc/kbdd
	optfeature "key_light" sys-power/upower
	optfeature "kubernetes" sys-cluster/kubectl
	optfeature "monitor_manager" "dev-lang/python[tk] media-fonts/fontawesome x11-apps/xrandr"
	optfeature "rofi-calendar" x11-misc/rofi
	optfeature "ssid and wlan-dbm" net-wireless/iw
	optfeature "temperature" sys-apps/lm-sensors
	optfeature "ytdl-mpv" "media-fonts/fontawesome media-video/mpv x11-misc/xclip net-misc/youtube-dl"
}
