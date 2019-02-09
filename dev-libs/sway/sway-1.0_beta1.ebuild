# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils fcaps meson pam

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

if [[ ${PV} == 9999 ]]; then
		inherit git-r3
		EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
		# Version format: major.minor-beta.betanum
		MY_PV="$(ver_cut 1-2)-$(ver_cut 3).$(ver_cut 4)"
		SRC_URI="https://github.com/swaywm/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${MY_PV}"
		KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="elogind fish-completion +swaybar +swaybg +swaylock systemd +tray wallpapers X zsh-completion"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.6.0:0=
	dev-libs/libpcre
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	elogind? ( >=sys-auth/elogind-237 )
	swaybar? ( x11-libs/gdk-pixbuf:2 )
	swaybg? ( x11-libs/gdk-pixbuf:2 )
	swaylock? (
		virtual/pam
		x11-libs/gdk-pixbuf:2
	)
	systemd? ( >=sys-apps/systemd-237 )
	tray? ( >=sys-apps/dbus-1.10 )
	X? ( x11-libs/libxcb:0=[xkb] )
"
if [[ ${PV} == 9999 ]]; then
	DEPEND+="~dev-libs/wlroots-9999[elogind=,filecaps?,systemd=,X=]"
else
	DEPEND+=">=dev-libs/wlroots-0.1[elogind=,filecaps?,systemd=,X=]"
fi
RDEPEND="
	x11-misc/xkeyboard-config
	${DEPEND}
"
BDEPEND="
	app-text/scdoc
	>=dev-libs/wayland-protocols-1.14
	virtual/pkgconfig
"

FILECAPS=( cap_sys_admin usr/bin/sway )

src_prepare() {
	default

	use swaybar || sed -e "s/subdir('swaybar')//g" -i meson.build || die
	use swaybg || sed -e "s/subdir('swaybg')//g" -i meson.build || die
	use swaylock || sed -e "s/subdir('swaylock')//g" -i meson.build || die
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

	if [[ ${PV} != 9999 ]]; then
		emesonargs+=("-Dsway-version=${MY_PV}")
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	use swaylock && newpamd swaylock/pam/swaylock.linux swaylock
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
		elog ""
		elog "If your system does not set the XDG_RUNTIME_DIR environment"
		elog "variable, you must set it manually to run Sway. See wiki"
		elog "for details: https://wiki.gentoo.org/wiki/Sway"
	fi
}
