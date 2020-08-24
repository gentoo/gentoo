# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Nibbles clone for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Nibbles"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=media-libs/clutter-1.22.0:1.0
	>=media-libs/clutter-gtk-1.4.0:1.0
	dev-libs/libgee:0.8=
	>=media-libs/gsound-1.0.2
	>=x11-libs/gtk+-3.18.0:3
	dev-libs/libgnome-games-support:1=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	media-libs/gsound[vala]
"

PATCHES=(
	"${FILESDIR}"/3.36.0-drop-unnecessary-files.patch # https://gitlab.gnome.org/GNOME/gnome-nibbles/merge_requests/11
)

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
