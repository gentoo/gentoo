# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils

DESCRIPTION="Support Ubuntu AppIndicators and KStatusNotifierItems in Gnome"
HOMEPAGE="https://github.com/ubuntu/gnome-shell-extension-appindicator"
SRC_URI="https://github.com/ubuntu/gnome-shell-extension-appindicator/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	dev-libs/libappindicator:3
	>=gnome-base/gnome-shell-3.34
"
DEPEND=""
BDEPEND=""

extension_uuid="appindicatorsupport@rgcjonas.gmail.com"

src_install() {
	einstalldocs
	dodoc AUTHORS.md

	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml

	rm -rf schemas/ AUTHORS.md LICENSE Makefile README.md || die
	insinto /usr/share/gnome-shell/extensions/"${extension_uuid}"
	doins -r *
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
