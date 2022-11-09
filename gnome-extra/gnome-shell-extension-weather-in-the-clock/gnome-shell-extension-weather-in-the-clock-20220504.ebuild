# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

DESCRIPTION="Display the current weather in the clock"
HOMEPAGE="https://github.com/JasonLG1979/gnome-shell-extension-weather-in-the-clock"
COMMIT="4c8dbc0831515e1b22d9b37601e83cebc2cc127d"
SRC_URI="https://github.com/JasonLG1979/gnome-shell-extension-weather-in-the-clock/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.38
	gnome-extra/gnome-weather
"
DEPEND=""
BDEPEND=""

extension_uuid="weatherintheclock@JasonLG1979.github.io"
S="${WORKDIR}/${PN}-${COMMIT}"

src_compile() { :; }

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
