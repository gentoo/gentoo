# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

DESCRIPTION="Display the current weather inside the pill next to the clock"
HOMEPAGE="https://github.com/CleoMenezesJr/weather-oclock"
SRC_URI="https://github.com/CleoMenezesJr/weather-oclock/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN/gnome-shell-extension-}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	=gnome-base/gnome-shell-47*
	gnome-extra/gnome-weather
	!gnome-extra/gnome-shell-extension-weather-in-the-clock
"

extension_uuid="weatheroclock@CleoMenezesJr.github.io"

src_install() {
	einstalldocs
	insinto /usr/share/gnome-shell/extensions/
	doins -r "${extension_uuid}"
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
