# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson readme.gentoo-r1 virtualx xdg

DESCRIPTION="Default file manager for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"

LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0"
IUSE="gnome gtk-doc +introspection packagekit +previewer seccomp selinux sendto"

KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	>=dev-libs/glib-2.55.1:2
	>=media-libs/gexiv2-0.10.0
	>=app-arch/gnome-autoar-0.2.1
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.22.27:3[X,introspection?]
	seccomp? ( sys-libs/libseccomp )
	>=x11-libs/pango-1.28.3
	selinux? ( >=sys-libs/libselinux-2.0 )
	>=app-misc/tracker-2.0:=
	x11-libs/libX11
	>=dev-libs/libxml2-2.7.8:2
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gdbus-codegen-2.51.2
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.10
		app-text/docbook-xml-dtd:4.1.2 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )
	seccomp? ( >=sys-apps/bubblewrap-0.3.1 )
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )
"

PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk(+)]
" # Need gvfs[gtk] for recent:/// support; always built (without USE=gtk) since gvfs-1.34

PATCHES=(
	"${FILESDIR}"/${PV}-docs-build.patch # Always install pregenerated manpage, keeping docs option for gtk-doc
	"${FILESDIR}"/${PV}-thumbnailer-updates{,2}.patch # syncs with gnome-desktop; fixes the ld.so.cache for us
	"${FILESDIR}"/${PV}-seccomp-sparc32.patch # 32-bit sparc doesn't have seccomp either
	"${FILESDIR}"/${PV}-CVE-2019-11461.patch
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
		$(meson_use gtk-doc docs)
		-Dextensions=true # image file properties, sendto support
		$(meson_use introspection)
		$(meson_use packagekit)
		$(meson_use selinux)
		-Dprofiling=false
		-Dtests=$(usex test all none)
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
	gnome2_schemas_update

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
