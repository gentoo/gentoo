# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.28"

inherit gnome2 meson vala

DESCRIPTION="Shotwell is a photo manager for GNOME 3"
HOMEPAGE="https://wiki.gnome.org/Apps/Shotwell/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	app-crypt/gcr:=[gtk,vala]
	dev-libs/libgdata:=[vala]
	dev-libs/libgee:=
	media-libs/gexiv2:=[introspection,vala]
	media-libs/libexif:=
	media-libs/libgphoto2:=
	media-libs/libraw:=
	net-libs/webkit-gtk:=
	x11-libs/gtk+:=[X]
"
DEPEND="
	${RDEPEND}
	$(vala_depend)
	dev-util/itstool
"

src_prepare() {
	vala_src_prepare
	eapply_user
}
