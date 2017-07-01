# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit virtualx

MY_P=${P^}

DESCRIPTION="File manager for the Xfce desktop environment"
HOMEPAGE="https://www.xfce.org/projects/ https://docs.xfce.org/xfce/thunar/start"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+dbus exif libnotify pcre test udisks +xfce_plugins_trash"

GVFS_DEPEND=">=gnome-base/gvfs-1.18.3"
COMMON_DEPEND=">=dev-lang/perl-5.6
	>=dev-libs/glib-2.30:=
	>=x11-libs/gdk-pixbuf-2.14:=
	>=x11-libs/gtk+-2.24:2=
	>=xfce-base/exo-0.10:=
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/libxfce4util-4.10.1:=
	>=xfce-base/xfconf-4.10:=
	dbus? ( >=dev-libs/dbus-glib-0.100:= )
	exif? ( >=media-libs/libexif-0.6.19:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	pcre? ( >=dev-libs/libpcre-6:= )
	udisks? ( virtual/libgudev:= )
	xfce_plugins_trash? ( >=xfce-base/xfce4-panel-4.10:= )"
RDEPEND="${COMMON_DEPEND}
	>=dev-util/desktop-file-utils-0.20-r1
	x11-misc/shared-mime-info
	dbus? ( ${GVFS_DEPEND} )
	udisks? (
		virtual/udev
		${GVFS_DEPEND}[udisks,udev]
		)
	xfce_plugins_trash? ( ${GVFS_DEPEND} )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
REQUIRED_USE="xfce_plugins_trash? ( dbus )"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog FAQ HACKING NEWS README THANKS TODO )

src_configure() {
	local myconf=(
		$(use_enable dbus)
		$(use_enable udisks gudev)
		$(use_enable libnotify notifications)
		$(use_enable exif)
		$(use_enable pcre)
		$(use_enable xfce_plugins_trash tpa-plugin)
	)

	econf "${myconf[@]}"
}

src_test() {
	virtx emake check
}
