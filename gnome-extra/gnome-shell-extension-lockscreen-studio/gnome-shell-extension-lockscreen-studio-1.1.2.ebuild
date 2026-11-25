# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

DESCRIPTION="Customization extension for the gnome-shell lock screen"
HOMEPAGE="https://github.com/phenrique-coder/lockscreen-studio"
SRC_URI="https://github.com/phenrique-coder/lockscreen-studio/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/gnome-shell-extension-}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-libs/glib:2
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-45
"

extension_uuid="lockscreen-studio@pedro.projects"

src_install() {
	einstalldocs
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
	insinto /usr/share/gnome-shell/extensions/"${extension_uuid}"
	doins metadata.json extension.js prefs.js
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
