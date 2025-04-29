# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Aleph One - Apotheosis X"
HOMEPAGE="https://www.moddb.com/mods/apotheosis-x"
SRC_URI="https://deps.gentoo.zip/games-fps/${PN}/Apotheosis_X_1.1.zip -> ${P}.zip"
S="${WORKDIR}/Apotheosis X 1.1"

LICENSE="bungie-marathon all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

RDEPEND="games-fps/alephone"
BDEPEND="app-arch/unzip"

MY_NAME="apotheosis-x"
MY_DIR="/usr/share/alephone-${MY_NAME}"

src_install() {
	insinto "${MY_DIR}"
	doins -r *

	mkdir "${D}${MY_DIR}"/Plugins

	make_desktop_entry "alephone.sh ${MY_NAME}" "${DESCRIPTION}"

	keepdir "${MY_DIR}"/{Music,Scripts,Plugins}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Apotheosis X is a total conversion for Aleph One, a game engine for the Marathon series."
		elog "It is a standalone game and does not require any other Marathon scenarios to play."
		elog "To play this scenario, run:"
		elog "\`alephone.sh ${MY_NAME}\` or use the menu entry."
		elog
		elog "Apotheosis X does not include a custom HUD, and by default will use the Marathon"
		elog "HUD which results in black bars covering a portion of usable screen real-estate."
		elog "The manual suggests the following plugins:"
		elog " - Basic HUD - https://simplici7y.com/items/basic-hud/"
		elog " - Fullscreen Corner HUD https://simplici7y.com/items/fullscreen-corner-hud/"
	fi
}
