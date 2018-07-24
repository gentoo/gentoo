# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils meson readme.gentoo-r1

DESCRIPTION="KDE Connect implementation for Gnome Shell"
HOMEPAGE="https://github.com/andyholmes/gnome-shell-extension-gsconnect"
SRC_URI="https://github.com/andyholmes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	dev-libs/folks:0=
	>=dev-libs/gjs-1.48
	dev-libs/glib:2
	dev-libs/libgdata:0=
	dev-python/nautilus-python
	>=gnome-base/gnome-shell-3.24
	gnome-base/nautilus
	net-fs/sshfs
	net-libs/gnome-online-accounts:0=
	|| ( media-libs/libcanberra media-libs/gsound )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="For knowing more about how to do the setup, please visit:
https://github.com/andyholmes/gnome-shell-extension-gsconnect/wiki/Installation"

src_install() {
	meson_src_install
	# Rule for install is not complete, only ready for install-zip
	glib-compile-schemas "${ED}"/usr/share/gnome-shell/extensions/gsconnect@andyholmes.github.io/schemas || die

	readme.gentoo_create_doc
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
