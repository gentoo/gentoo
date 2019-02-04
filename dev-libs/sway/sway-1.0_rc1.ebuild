# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]] ; then
		EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
		inherit git-r3
else
		# Version format: major.minor-rc#
		SWAY_PV="$(ver_cut 1-2)-$(ver_cut 3-4)"
		SRC_URI="https://github.com/swaywm/${PN}/archive/${SWAY_PV}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${SWAY_PV}"
		KEYWORDS="~amd64 ~x86"
fi

inherit eutils fcaps meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

LICENSE="MIT"
SLOT="0"
IUSE="elogind fish-completion +gdk-pixbuf +man +swaybar +swaybg +swaymsg +swaynag systemd tray wallpapers X zsh-completion"
REQUIRED_USE="?? ( elogind systemd )
	tray? ( || ( elogind systemd ) )"

DEPEND="~dev-libs/wlroots-0.3[systemd=,elogind=,X=]
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.6.0:0=
	dev-libs/libpcre
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	elogind? ( >=sys-auth/elogind-239 )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2 )
	systemd? ( >=sys-apps/systemd-239 )
	X? ( x11-libs/libxcb:0= )"
RDEPEND="x11-misc/xkeyboard-config
	${DEPEND}"
BDEPEND=">=dev-libs/wayland-protocols-1.14
	>=dev-util/meson-0.48
	virtual/pkgconfig
	man? ( >=app-text/scdoc-1.8.1 )"

FILECAPS=( cap_sys_admin usr/bin/sway )

src_prepare() {
	default

	use swaybar || sed -e "s/subdir('swaybar')//g" -e "/sway-bar.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaybar/d" -i meson.build || die
	use swaybg || sed -e "s/subdir('swaybg')//g" -i meson.build || die
	use swaymsg || sed -e "s/subdir('swaymsg')//g" -e "/swaymsg.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaymsg/d" -i meson.build || die
	use swaynag || sed -e "s/subdir('swaynag')//g" -e "/swaynag.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaynag/d" -i meson.build || die
}

src_configure() {
	local emesonargs=(
		"-Dsway-version=${SWAY_PV}"
		-Ddefault-wallpaper=$(usex wallpapers true false)
		-Dfish-completions=$(usex fish-completion true false)
		-Dgdk-pixbuf=$(usex gdk-pixbuf enabled disabled)
		-Dman-pages=$(usex man enabled disabled)
		-Dtray=$(usex tray enabled disabled)
		-Dzsh-completions=$(usex zsh-completion true false)
		-Dxwayland=$(usex X enabled disabled)
		"-Dbash-completions=true"
		"-Dwerror=false"
	)

	meson_src_configure
}

pkg_postinst() {
	elog "You must be in the input group to allow sway to access input devices!"
	if use tray ; then
		elog ""
		optfeature "experimental xembed tray icons support" kde-plasma/xembed-sni-proxy
	fi
	if ! use systemd && ! use elogind ; then
		fcaps_pkg_postinst
		elog ""
		elog "If you use ConsoleKit2, remember to launch sway using:"
		elog "exec ck-launch-session sway"
		elog ""
		elog "If your system does not set the XDG_RUNTIME_DIR environment"
		elog "variable, you must set it manually to run Sway. See wiki"
		elog "for details: https://wiki.gentoo.org/wiki/Sway"
	fi
}
