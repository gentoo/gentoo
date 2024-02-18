# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils meson readme.gentoo-r1 virtualx xdg

DESCRIPTION="KDE Connect implementation for Gnome Shell"
HOMEPAGE="https://github.com/GSConnect/gnome-shell-extension-gsconnect"
SRC_URI="https://github.com/GSConnect/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nautilus"

COMMON_DEPEND="dev-libs/glib:2"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=dev-libs/gjs-1.68
	=gnome-base/gnome-shell-45*
	gnome-base/gvfs
	gnome-extra/evolution-data-server
	|| ( media-libs/libcanberra media-libs/gsound )
	nautilus? (
		dev-python/nautilus-python
		gnome-base/nautilus[introspection] )
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="For knowing more about how to do the setup, please visit:
https://github.com/GSConnect/gnome-shell-extension-gsconnect/wiki/Installation"

src_configure() {
	# nemo support relies on nemo-python from https://github.com/linuxmint/nemo-extensions
	# https://bugs.gentoo.org/694388
	meson_src_configure \
		-Dinstalled_tests=false \
		-Dnemo=false \
		$(meson_use nautilus)
}

src_test() {
	virtx meson_src_test
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_preinst() {
	gnome2_schemas_savelist
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
