# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils

DESCRIPTION="Allow to connect bluetooth paired devices from gnome control panel"
HOMEPAGE="https://github.com/bjarosze/gnome-bluetooth-quick-connect"
SRC_URI="https://github.com/bjarosze/gnome-bluetooth-quick-connect/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	net-wireless/bluez
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.38
"
DEPEND="${COMMON_DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P/shell-extension-}"

src_install() {
	einstalldocs
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
	rm -rf README.md LICENSE Makefile schemas || die
	insinto /usr/share/gnome-shell/extensions/bluetooth-quick-connect@bjarosze.gmail.com
	doins -r *
	dosym ../../../../../usr/share/glib-2.0/schemas /usr/share/gnome-shell/extensions/bluetooth-quick-connect@bjarosze.gmail.com/schemas
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
