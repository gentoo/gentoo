# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unofficial extension pack providing GNOME 2-like features"
HOMEPAGE="https://frippery.org/extensions/index.html"
SRC_URI="https://frippery.org/extensions/${P}.tgz"
S="${WORKDIR}/.local/share/gnome-shell"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	gnome-base/gnome-menus:3[introspection]
	>=gnome-base/gnome-shell-48
"

src_install() {
	insinto /usr/share/gnome-shell/extensions
	doins -r extensions/*@*
	dodoc gnome-shell-frippery/{CHANGELOG,README}
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
