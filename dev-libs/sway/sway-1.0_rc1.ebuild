# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils fcaps meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/sway.git"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://github.com/swaywm/sway/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="bash-completion clipboard doc elogind fish-completion +swaybar +swaybg +swayidle +swaylock +swaymsg +swaynag systemd +tray wallpapers X zsh-completion"
REQUIRED_USE="?? ( elogind systemd )"

RDEPEND="
	>=dev-libs/wlroots-0.3[elogind=,systemd=,X=]
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.6.0:0=
	dev-libs/libpcre
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	sys-libs/libcap
	clipboard? ( dev-libs/wl-clipboard )
	elogind? ( >=sys-auth/elogind-239 )
	swaybar? ( x11-libs/gdk-pixbuf:2[jpeg] )
	swaybg? ( x11-libs/gdk-pixbuf:2[jpeg] )
	swayidle? ( dev-libs/swayidle )
	swaylock? ( dev-libs/swaylock )
	systemd? ( >=sys-apps/systemd-239 )
	tray? ( >=sys-apps/dbus-1.10 )
	X? ( x11-libs/libxcb:0= )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	doc? ( >=app-text/scdoc-1.8.1 )
	virtual/pkgconfig"

FILECAPS=( cap_sys_admin usr/bin/sway )

src_prepare() {
	default

	use swaybar || sed -e "s/subdir('swaybar')//g" -i meson.build || die
	use swaybg || sed -e "s/subdir('swaybg')//g" -i meson.build || die
	use swaymsg || sed -e "s/subdir('swaymsg')//g" -e "/swaymsg.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaymsg/d" -i meson.build || die
	use swaynag || sed -e "s/subdir('swaynag')//g" -e "/swaynag.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaynag/d" -i meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use bash-completion bash-completions)
		$(meson_use fish-completion fish-completions)
		$(meson_use wallpapers default-wallpaper)
		$(meson_use zsh-completion zsh-completions)
		"-Dtray=$(usex tray enabled disabled)"
		"-Dxwayland=$(usex X enabled disabled)"
		"-Dwerror=false"
	)
	if use swaybar || use swaybg; then
		emesonargs+=("-Dgdk-pixbuf=enabled")
	else
		emesonargs+=("-Dgdk-pixbuf=disabled")
	fi
	if [[ ${PV} != 9999 ]]; then
		emesonargs+=("-Dsway-version=${PV}")
	fi

	meson_src_configure
}

pkg_postinst() {
	elog "You must be in the input group to allow sway to access input devices!"
	local dbus_cmd=""
	if use tray; then
		dbus_cmd="dbus-launch --sh-syntax --exit-with-session "
	fi
	if ! use systemd && ! use elogind; then
		fcaps_pkg_postinst
		elog ""
		elog "If you use ConsoleKit2, remember to launch sway using:"
		elog "exec ck-launch-session ${dbus_cmd}sway"
	fi
}
