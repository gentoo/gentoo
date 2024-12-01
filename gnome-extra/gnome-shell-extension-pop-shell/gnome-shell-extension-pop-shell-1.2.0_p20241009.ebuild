# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils optfeature readme.gentoo-r1

EGIT_COMMIT="e25621e2595eb5235ecb1a41167d1324a2b2a297"

DESCRIPTION="Keyboard-driven layer for GNOME Shell with tiling support"
HOMEPAGE="https://github.com/pop-os/shell"
SRC_URI="https://github.com/pop-os/shell/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/shell-${EGIT_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-45
	sys-apps/fd
"
BDEPEND="dev-lang/typescript"

DOC_CONTENTS="To configure keybindings run /usr/lib/pop-shell/scripts/configure.sh as user"

src_install() {
	default

	insinto /usr/share/glib-2.0/schemas
	doins schemas/org.gnome.shell.extensions.pop-shell.gschema.xml

	exeinto /usr/lib/pop-shell/scripts
	doexe scripts/configure.sh

	insinto /usr/share/gnome-control-center/keybindings
	doins keybindings/*.xml

	readme.gentoo_create_doc
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?

	gnome2_schemas_update

	readme.gentoo_print_elog
	optfeature "better tiling via native-window-placement" gnome-extra/gnome-shell-extensions
}

pkg_postrm() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?

	gnome2_schemas_update
}
