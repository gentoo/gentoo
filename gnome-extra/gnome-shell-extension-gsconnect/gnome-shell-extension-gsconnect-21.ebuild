# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils meson readme.gentoo-r1

DESCRIPTION="KDE Connect implementation for Gnome Shell"
HOMEPAGE="https://github.com/andyholmes/gnome-shell-extension-gsconnect"
SRC_URI="https://github.com/andyholmes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nautilus"

COMMON_DEPEND="dev-libs/glib:2"

RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=dev-libs/gjs-1.48
	>=gnome-base/gnome-shell-3.28
	gnome-base/gvfs
	|| ( ( net-libs/gnome-online-accounts dev-libs/libgdata ) dev-libs/folks )
	|| ( media-libs/libcanberra media-libs/gsound )
	nautilus? (
		dev-python/nautilus-python
		gnome-base/nautilus[introspection] )
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="virtual/pkgconfig"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="For knowing more about how to do the setup, please visit:
https://github.com/andyholmes/gnome-shell-extension-gsconnect/wiki/Installation"

src_configure() {
	meson_src_configure \
		$(meson_use nautilus)
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_schemas_update
}
