# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit optfeature toolchain-funcs

COMMIT=9d66d81da8d521941a349da26457f4965fd6fcbd

DESCRIPTION="A set of scripts for i3blocks, contributed by the community"
HOMEPAGE="https://github.com/vivien/i3blocks-contrib"
SRC_URI="https://github.com/vivien/i3blocks-contrib/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND=">=x11-misc/i3blocks-1.5"

PATCHES=(
	"${FILESDIR}"/${P}-respect-CFLAGS.patch
	"${FILESDIR}"/${PN}-2.0.0-fix-build-on-clang-llvm.patch
)

src_prepare() {
	sed -i -e '/^$(_BLOCKS):/ s/$/ installdirs/' Makefile
	default
}

src_compile() {
	tc-export AR CC LD
	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}

pkg_postinst() {
	optfeature_header "The following deps may be required for certain ${PN} scripts:"
	optfeature "backlight" sys-power/acpilight x11-apps/xbacklight
	optfeature "battery{,2,bar}" sys-power/acpi
	optfeature "colorpicker" x11-misc/grabc x11-misc/xdotool
	optfeature "cpu_usage" app-admin/sysstat
	optfeature "disk-io" app-admin/sysstat
	optfeature "email" dev-python/keyring gnome-base/gnome-keyring
	optfeature "eyedropper" media-fonts/fontawesome x11-misc/grabc x11-misc/xclip
	optfeature "github" dev-util/github-cli media-fonts/fontawesome
	optfeature "gpu-load" x11-drivers/nvidia-drivers app-misc/radeontop
	optfeature "i3-focusedwindow" x11-apps/xprop
	optfeature "kbdd_layout" x11-misc/kbdd
	optfeature "key_light" sys-power/upower
	optfeature "kubernetes" sys-cluster/kubectl
	optfeature "monitor_manager" "dev-lang/python[tk] media-fonts/fontawesome x11-apps/xrandr"
	optfeature "purpleair" app-misc/jq net-misc/curl
	optfeature "rofi-calendar" x11-misc/rofi
	optfeature "ssid and wlan-dbm" net-wireless/iw
	optfeature "temperature" sys-apps/lm-sensors
	optfeature "ytdl-mpv" "media-fonts/fontawesome media-video/mpv[lua] x11-misc/xclip net-misc/yt-dlp"
}
