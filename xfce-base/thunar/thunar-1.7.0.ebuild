# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils virtualx xdg-utils

MY_P=${P^}

DESCRIPTION="File manager for the Xfce desktop environment"
HOMEPAGE="https://www.xfce.org/projects/ https://docs.xfce.org/xfce/thunar/start"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="exif introspection libnotify pcre test +trash-panel-plugin udisks"

GVFS_DEPEND=">=gnome-base/gvfs-1.18.3"
COMMON_DEPEND=">=dev-lang/perl-5.6
	>=dev-libs/glib-2.30:=
	>=x11-libs/gdk-pixbuf-2.14:=
	>=x11-libs/gtk+-3.20:3=
	>=xfce-base/exo-0.11:=
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfconf-4.12:=
	exif? ( >=media-libs/libexif-0.6.19:= )
	introspection? ( dev-libs/gobject-introspection:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	pcre? ( >=dev-libs/libpcre-6:= )
	trash-panel-plugin? ( >=xfce-base/xfce4-panel-4.10:= )
	udisks? ( virtual/libgudev:= )"
RDEPEND="${COMMON_DEPEND}
	>=dev-util/desktop-file-utils-0.20-r1
	x11-misc/shared-mime-info
	trash-panel-plugin? ( ${GVFS_DEPEND} )
	udisks? (
		virtual/udev
		${GVFS_DEPEND}[udisks,udev]
		)"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog FAQ HACKING NEWS README THANKS TODO )
PATCHES=(
	"${FILESDIR}"/thunar-1.16.2-integer-overflow.patch
)

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable udisks gudev)
		$(use_enable libnotify notifications)
		$(use_enable exif)
		$(use_enable pcre)
		$(use_enable trash-panel-plugin tpa-plugin)
	)

	econf "${myconf[@]}"
}

src_test() {
	virtx emake check
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
