# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Allow to connect bluetooth paired devices from gnome control panel"
HOMEPAGE="https://github.com/bjarosze/gnome-bluetooth-quick-connect"
SRC_URI="https://github.com/bjarosze/gnome-bluetooth-quick-connect/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# glib for glib-compile-schemas at build time, needed at runtime anyways
COMMON_DEPEND="
	dev-libs/glib:2
"
RDEPEND="${COMMON_DEPEND}
	net-wireless/bluez
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.36
"
DEPEND="${COMMON_DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P/shell-extension-}"

src_install() {
	einstalldocs
	rm -f README.md LICENSE Makefile || die
	insinto /usr/share/gnome-shell/extensions/bluetooth-quick-connect@bjarosze.gmail.com
	doins -r *
	glib-compile-schemas "${ED}"/usr/share/gnome-shell/extensions/bluetooth-quick-connect@bjarosze.gmail.com/schemas || die
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
