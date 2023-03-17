# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Screen saver and locker (port of MATE screensaver)"
HOMEPAGE="
	https://docs.xfce.org/apps/screensaver/start
	https://gitlab.xfce.org/apps/xfce4-screensaver/
"
SRC_URI="
	https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2
	https://gitlab.xfce.org/apps/xfce4-screensaver/-/commit/7aeced1f6fb39fd8887fc441b4ff491ba5bfcf35.patch
		-> ${P}-mem.patch
"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~loong ppc ~ppc64 ~riscv x86"
IUSE="elogind +locking opengl pam systemd"

# Xrandr: optional but automagic
DEPEND="
	>=dev-libs/dbus-glib-0.30
	>=dev-libs/glib-2.50:2
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libwnck-3.20:3
	x11-libs/libICE:=
	x11-libs/libX11:=
	x11-libs/libXScrnSaver:=
	x11-libs/libXext:=
	x11-libs/libXxf86vm:=
	>=x11-libs/libXrandr-1.3:=
	>=x11-libs/libxklavier-5.2:=
	>=xfce-base/garcon-0.5.0:=
	>=xfce-base/libxfce4ui-4.12.1:=
	>=xfce-base/libxfce4util-4.12.1:=
	>=xfce-base/xfconf-4.12.1:=
	elogind? ( sys-auth/elogind )
	locking? (
		pam? ( sys-libs/pam )
	)
	opengl? ( virtual/opengl )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/glib-utils
	dev-util/intltool
	sys-apps/dbus
	virtual/pkgconfig
"

PATCHES=(
	"${DISTDIR}/${P}-mem.patch"
)

src_configure() {
	local myconf=(
		# disable docbook for now
		ac_cv_path_XMLTO=no

		# xscreensaver dirs autodetection doesn't seem to work
		--with-xscreensaverdir=/usr/share/xscreensaver/config
		--with-xscreensaverhackdir=/usr/$(get_libdir)/misc/xscreensaver
		--without-console-kit

		$(use_with opengl libgl)
		$(use_enable locking)
		$(use_enable pam)
		$(use_with elogind)
		$(use_with systemd)
	)

	if use pam; then
		myconf+=( --with-pam-auth-type=system )
	fi

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
