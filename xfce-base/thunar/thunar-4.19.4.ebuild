# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="File manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/thunar/start
	https://gitlab.xfce.org/xfce/thunar/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="exif introspection libnotify pcre +trash-panel-plugin udisks"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gdk-pixbuf-2.42.8
	>=x11-libs/gtk+-3.24.0:3[X]
	>=xfce-base/exo-4.19.0:=
	>=xfce-base/libxfce4ui-4.17.6:=
	>=xfce-base/libxfce4util-4.17.2:=
	>=xfce-base/xfconf-4.12:=
	exif? ( >=media-libs/libexif-0.6.19:= )
	introspection? ( dev-libs/gobject-introspection:= )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	pcre? ( >=dev-libs/libpcre2-10.0:= )
	trash-panel-plugin? ( >=xfce-base/xfce4-panel-4.10:= )
	udisks? ( dev-libs/libgudev:= )
"
RDEPEND="
	${DEPEND}
	>=dev-util/desktop-file-utils-0.20-r1
	x11-misc/shared-mime-info
	trash-panel-plugin? (
		>=gnome-base/gvfs-1.18.3
	)
	udisks? (
		>=gnome-base/gvfs-1.18.3[udisks,udev]
		virtual/udev
	)
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable udisks gudev)
		$(use_enable libnotify notifications)
		$(use_enable exif)
		$(use_enable pcre pcre2)
		$(use_enable trash-panel-plugin tpa-plugin)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "If you were using an older Xfce version and Thunar fails to start"
	elog "with a message similar to:"
	elog "  Failed to register: Timeout was reached"
	elog "you may need to reset your xfce4 session:"
	elog "  rm ~/.cache/sessions/xfce4-session-*"
	elog "See https://bugs.gentoo.org/698914."

	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
