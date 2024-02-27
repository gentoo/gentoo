# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils meson

DESCRIPTION="Support legacy, AppIndicators and KStatusNotifierItems in Gnome"
HOMEPAGE="https://github.com/ubuntu/gnome-shell-extension-appindicator"
SRC_URI="https://github.com/ubuntu/gnome-shell-extension-appindicator/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-45
"
BDEPEND="
	app-misc/jq
"

src_prepare() {
	default
	# https://github.com/ubuntu/gnome-shell-extension-appindicator/issues/419
	eapply -R "${FILESDIR}/${PN}-53-41a8e9c.patch"
}

src_install() {
	meson_src_install
	rm "${ED}"/usr/share/glib-2.0/schemas/gschemas.compiled || die
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_schemas_update
}
