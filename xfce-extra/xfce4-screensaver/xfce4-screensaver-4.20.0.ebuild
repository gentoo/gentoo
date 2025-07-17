# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Screen saver and locker (port of MATE screensaver)"
HOMEPAGE="
	https://docs.xfce.org/apps/screensaver/start
	https://gitlab.xfce.org/apps/xfce4-screensaver/
"
SRC_URI="
	https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
# TODO: wayland requires libwlembed
IUSE="elogind +locking pam systemd X"
REQUIRED_USE="
	X
	?? ( elogind systemd )
"

DEPEND="
	>=dev-libs/dbus-glib-0.30
	>=dev-libs/glib-2.50.0:2
	>=x11-libs/gtk+-3.24.0:3[X?]
	>=xfce-base/garcon-4.16.0:=
	>=xfce-base/libxfce4ui-4.18.4:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	X? (
		>=x11-libs/libwnck-3.20:3
		>=x11-libs/libX11-1.6.7:=
		>=x11-libs/libXScrnSaver-1.2.3:=
		>=x11-libs/libXext-1.0.0:=
		>=x11-libs/libxklavier-5.2:=
	)
	elogind? ( sys-auth/elogind )
	locking? (
		pam? ( sys-libs/pam )
	)
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/glib-utils
	sys-apps/dbus
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local auth_scheme session_manager

	# upstream has no "none" option, but pwent + !locking + !shadow
	# disables all dependency checks
	if use locking && use pam; then
		auth_scheme=pam
	else
		auth_scheme=pwent
	fi
	if use systemd; then
		session_manager=systemd
	elif use elogind; then
		session_manager=elogind
	else
		# not exactly the same as disabled but it has no deps
		session_manager=consolekit
	fi

	local emesonargs=(
		-Dauthentication-scheme=${auth_scheme}
		-Dsession-manager=${session_manager}
		$(meson_feature X x11)
		-Dwayland=disabled
		-Dxscreensaverhackdir="${EPREFIX}/usr/$(get_libdir)/misc/xscreensaver"
		-Dkbd-layout-indicator=true
		# disable docbook for now
		-Ddocs=disabled
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		$(meson_use locking)
		# used only with -Dauthentication-scheme=pam
		-Dpam-auth-type=system
		# used only with -Dauthentication-scheme=pwent
		# locking + shadow = shadow-based locking
		# !locking + !shadow = no locking and no dependencies
		$(meson_use locking shadow)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
