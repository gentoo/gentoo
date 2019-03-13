# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson readme.gentoo-r1 virtualx xdg

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"

LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0"
IUSE="exif gnome gtk-doc +introspection packagekit +previewer selinux sendto tracker xmp"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	>=dev-libs/glib-2.51.2:2
	>=gnome-base/gnome-desktop-3.0.0:3=
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.22.6:3[X,introspection?]
	>=dev-libs/libxml2-2.7.8:2
	exif? ( >=media-libs/libexif-0.6.20 )
	xmp? ( >=media-libs/exempi-2.1.0:2 )
	>=gnome-base/gsettings-desktop-schemas-3.8.0
	>=app-arch/gnome-autoar-0.2.1
	selinux? ( >=sys-libs/libselinux-2.0 )
	x11-libs/libX11
	tracker? ( >=app-misc/tracker-1:= )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gdbus-codegen-2.51.2
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.10 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )
"

PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk(+)]
"
# Need gvfs[gtk] for recent:/// support; always built (without USE=gtk) since gvfs-1.34

PATCHES=(
	"${FILESDIR}"/${PV}-file-view-crash-fix.patch
	"${FILESDIR}"/${PV}-optional-tracker.patch
	"${FILESDIR}"/${PV}-optional-introspection.patch
)

src_prepare() {
	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Denable-profiling=false
		$(meson_use introspection)
		$(meson_use sendto enable-nst-extension)
		$(meson_use exif enable-exif)
		$(meson_use tracker)
		$(meson_use xmp enable-xmp)
		$(meson_use selinux enable-selinux)
		-Denable-desktop=true
		$(meson_use packagekit enable-packagekit)
		$(meson_use gtk-doc enable-gtk-doc)
	)
	meson_src_configure
}

src_install() {
	use previewer && readme.gentoo_create_doc
	meson_src_install
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
	gnome2_schemas_update
}
