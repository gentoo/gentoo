# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils optfeature

EGIT_COMMIT=475b49dc02386e26fbe6b91a559c77515d96caaf

DESCRIPTION="Keyboard-driven layer for GNOME Shell with tiling support"
HOMEPAGE="https://github.com/pop-os/shell"
SRC_URI="https://github.com/pop-os/shell/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-40.1
	sys-apps/fd
"

BDEPEND="dev-lang/typescript"

S="${WORKDIR}/shell-${EGIT_COMMIT}"

src_install() {
	default

	insinto /usr/share/glib-2.0/schemas
	doins schemas/org.gnome.shell.extensions.pop-shell.gschema.xml

	exeinto /usr/lib/pop-shell/scripts
	doexe scripts/configure.sh

	insinto /usr/share/gnome-control-center/keybindings
	doins keybindings/*.xml
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?

	gnome2_schemas_update

	echo
	elog "To configure keybindings run /usr/lib/pop-shell/scripts/configure.sh as user"
	echo

	optfeature gnome-extra/gnome-shell-extensions "better tiling via native-window-placement"
}

pkg_postrm() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?

	gnome2_schemas_update
}
