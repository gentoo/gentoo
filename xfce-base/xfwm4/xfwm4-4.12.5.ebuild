# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Window manager for the Xfce desktop environment"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="dri startup-notification +xcomposite"

RDEPEND="dev-libs/dbus-glib:=
	>=dev-libs/glib-2.20:=
	>=x11-libs/gtk+-2.24:2=
	x11-libs/libX11:=
	x11-libs/libXext:=
	x11-libs/libXinerama:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/pango:=
	>=x11-libs/libwnck-2.30:1=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/libxfce4ui-4.11:=
	>=xfce-base/xfconf-4.10:=
	startup-notification? ( x11-libs/startup-notification:= )
	xcomposite? (
		x11-libs/libXcomposite:=
		x11-libs/libXdamage:=
		x11-libs/libXfixes:=
		)"
# libdrm: only headers are used
# libICE/liBSM: not really used anywhere but checked by configure
#   https://bugzilla.xfce.org/show_bug.cgi?id=11914
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	x11-libs/libICE
	x11-libs/libSM
	xfce-base/exo
	virtual/pkgconfig
	dri? ( >=x11-libs/libdrm-2.4 )"

DOCS=( AUTHORS ChangeLog COMPOSITOR NEWS README TODO )

src_configure() {
	local myconf=(
		$(use_enable dri libdrm)
		$(use_enable startup-notification)
		--enable-xsync
		--enable-render
		--enable-randr
		$(use_enable xcomposite compositor)
	)

	econf "${myconf[@]}"
}
