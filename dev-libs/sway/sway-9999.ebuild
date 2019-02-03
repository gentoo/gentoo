# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]] ; then
		EGIT_REPO_URI="https://github.com/swaywm/sway.git"
		inherit git-r3
else
		# Version format: major.minor-beta.betanum
		SWAY_PV="$(ver_cut 1-2)-$(ver_cut 3).$(ver_cut 4)"
		SRC_URI="https://github.com/swaywm/sway/archive/${SWAY_PV}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/sway-${SWAY_PV}"
		KEYWORDS="~amd64 ~x86"
fi

inherit eutils fcaps meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

LICENSE="MIT"
SLOT="0"
IUSE="elogind fish-completion +pam +swaybar +swaybg +swayidle +swaylock +swaymsg +swaynag systemd +tray wallpapers X zsh-completion"
REQUIRED_USE="?? ( elogind systemd )"

RDEPEND="~dev-libs/wlroots-9999[systemd=,elogind=,X=]
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.6.0:0=
	dev-libs/libpcre
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	elogind? ( >=sys-auth/elogind-237 )
	swaybar? ( x11-libs/gdk-pixbuf:2[jpeg] )
	swaybg? ( x11-libs/gdk-pixbuf:2[jpeg] )
	swaylock? (
		pam? ( virtual/pam )
		x11-libs/gdk-pixbuf:2[jpeg]
	)
	systemd? ( >=sys-apps/systemd-237 )
	tray? ( >=sys-apps/dbus-1.10 )
	X? ( x11-libs/libxcb:0= )"
DEPEND="${RDEPEND}"
BDEPEND="app-text/scdoc
	virtual/pkgconfig"

FILECAPS=( cap_sys_admin usr/bin/sway )

src_prepare() {
	default

	use swaybar || sed -e "s/subdir('swaybar')//g" -i meson.build || die
	use swaybg || sed -e "s/subdir('swaybg')//g" -i meson.build || die
	use swayidle || sed -e "s/subdir('swayidle')//g" -e "/swayidle.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swayidle/d" -i meson.build || die
	use swaylock || sed -e "s/subdir('swaylock')//g" -e "/swaylock.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaylock/d" -i meson.build || die
	use swaymsg || sed -e "s/subdir('swaymsg')//g" -e "/swaymsg.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaymsg/d" -i meson.build || die
	use swaynag || sed -e "s/subdir('swaynag')//g" -e "/swaynag.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaynag/d" -i meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use wallpapers default-wallpaper)
		$(meson_use zsh-completion zsh-completions)
		$(meson_use fish-completion fish-completions)
		$(meson_use X enable-xwayland)
		"-Dbash-completions=true"
		"-Dwerror=false"
	)

	meson_src_configure
}

pkg_postinst() {
	elog "You must be in the input group to allow sway to access input devices!"
	local dbus_cmd=""
	if use tray ; then
		elog ""
		optfeature "experimental xembed tray icons support" kde-plasma/xembed-sni-proxy
		dbus_cmd="dbus-launch --sh-syntax --exit-with-session "
	fi
	if ! use systemd && ! use elogind ; then
		fcaps_pkg_postinst
		elog ""
		elog "If you use ConsoleKit2, remember to launch sway using:"
		elog "exec ck-launch-session ${dbus_cmd}sway"
	fi
	if use swaylock && ! use pam; then
		fcaps cap_sys_admin usr/bin/swaylock
	fi
}
