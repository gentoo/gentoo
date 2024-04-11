# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=" Soothing pastel mouse cursors."
HOMEPAGE="https://github.com/catppuccin"

MY_URI="https://github.com/catppuccin/cursors/releases/download/v${PV}/"
MY_FRAPPE="Catppuccin-Frappe"
MY_LATTE="Catppuccin-Latte"
MY_MACCHIATO="Catppuccin-Macchiato"
MY_MOCHA="Catppuccin-Mocha"

SRC_URI="
	frappe? (
		${MY_URI}/${MY_FRAPPE}-Blue-Cursors.zip      -> ${P}-frappe-blue.zip
		${MY_URI}/${MY_FRAPPE}-Flamingo-Cursors.zip  -> ${P}-frappe-flamingo.zip
		${MY_URI}/${MY_FRAPPE}-Green-Cursors.zip     -> ${P}-frappe-green.zip
		${MY_URI}/${MY_FRAPPE}-Lavender-Cursors.zip  -> ${P}-frappe-lavender.zip
		${MY_URI}/${MY_FRAPPE}-Maroon-Cursors.zip    -> ${P}-frappe-maroon.zip
		${MY_URI}/${MY_FRAPPE}-Mauve-Cursors.zip     -> ${P}-frappe-mauve.zip
		${MY_URI}/${MY_FRAPPE}-Peach-Cursors.zip     -> ${P}-frappe-peach.zip
		${MY_URI}/${MY_FRAPPE}-Pink-Cursors.zip      -> ${P}-frappe-pink.zip
		${MY_URI}/${MY_FRAPPE}-Red-Cursors.zip       -> ${P}-frappe-red.zip
		${MY_URI}/${MY_FRAPPE}-Rosewater-Cursors.zip -> ${P}-frappe-rosewater.zip
		${MY_URI}/${MY_FRAPPE}-Sapphire-Cursors.zip  -> ${P}-frappe-sapphire.zip
		${MY_URI}/${MY_FRAPPE}-Sky-Cursors.zip       -> ${P}-frappe-sky.zip
		${MY_URI}/${MY_FRAPPE}-Teal-Cursors.zip      -> ${P}-frappe-teal.zip
		${MY_URI}/${MY_FRAPPE}-Yellow-Cursors.zip    -> ${P}-frappe-yellow.zip
	)
	latte? (
		${MY_URI}/${MY_LATTE}-Blue-Cursors.zip      -> ${P}-latte-blue.zip
		${MY_URI}/${MY_LATTE}-Flamingo-Cursors.zip  -> ${P}-latte-flamingo.zip
		${MY_URI}/${MY_LATTE}-Green-Cursors.zip     -> ${P}-latte-green.zip
		${MY_URI}/${MY_LATTE}-Lavender-Cursors.zip  -> ${P}-latte-lavender.zip
		${MY_URI}/${MY_LATTE}-Maroon-Cursors.zip    -> ${P}-latte-maroon.zip
		${MY_URI}/${MY_LATTE}-Mauve-Cursors.zip     -> ${P}-latte-mauve.zip
		${MY_URI}/${MY_LATTE}-Peach-Cursors.zip     -> ${P}-latte-peach.zip
		${MY_URI}/${MY_LATTE}-Pink-Cursors.zip      -> ${P}-latte-pink.zip
		${MY_URI}/${MY_LATTE}-Red-Cursors.zip       -> ${P}-latte-red.zip
		${MY_URI}/${MY_LATTE}-Rosewater-Cursors.zip -> ${P}-latte-rosewater.zip
		${MY_URI}/${MY_LATTE}-Sapphire-Cursors.zip  -> ${P}-latte-sapphire.zip
		${MY_URI}/${MY_LATTE}-Sky-Cursors.zip       -> ${P}-latte-sky.zip
		${MY_URI}/${MY_LATTE}-Teal-Cursors.zip      -> ${P}-latte-teal.zip
		${MY_URI}/${MY_LATTE}-Yellow-Cursors.zip    -> ${P}-latte-yellow.zip
	)
	macchiato? (
		${MY_URI}/${MY_MACCHIATO}-Blue-Cursors.zip      -> ${P}-macchiato-blue.zip
		${MY_URI}/${MY_MACCHIATO}-Flamingo-Cursors.zip  -> ${P}-macchiato-flamingo.zip
		${MY_URI}/${MY_MACCHIATO}-Green-Cursors.zip     -> ${P}-macchiato-green.zip
		${MY_URI}/${MY_MACCHIATO}-Lavender-Cursors.zip  -> ${P}-macchiato-lavender.zip
		${MY_URI}/${MY_MACCHIATO}-Maroon-Cursors.zip    -> ${P}-macchiato-maroon.zip
		${MY_URI}/${MY_MACCHIATO}-Mauve-Cursors.zip     -> ${P}-macchiato-mauve.zip
		${MY_URI}/${MY_MACCHIATO}-Peach-Cursors.zip     -> ${P}-macchiato-peach.zip
		${MY_URI}/${MY_MACCHIATO}-Pink-Cursors.zip      -> ${P}-macchiato-pink.zip
		${MY_URI}/${MY_MACCHIATO}-Red-Cursors.zip       -> ${P}-macchiato-red.zip
		${MY_URI}/${MY_MACCHIATO}-Rosewater-Cursors.zip -> ${P}-macchiato-rosewater.zip
		${MY_URI}/${MY_MACCHIATO}-Sapphire-Cursors.zip  -> ${P}-macchiato-sapphire.zip
		${MY_URI}/${MY_MACCHIATO}-Sky-Cursors.zip       -> ${P}-macchiato-sky.zip
		${MY_URI}/${MY_MACCHIATO}-Teal-Cursors.zip      -> ${P}-macchiato-teal.zip
		${MY_URI}/${MY_MACCHIATO}-Yellow-Cursors.zip    -> ${P}-macchiato-yellow.zip
	)
	mocha? (
		${MY_URI}/${MY_MOCHA}-Blue-Cursors.zip      -> ${P}-mocha-blue.zip
		${MY_URI}/${MY_MOCHA}-Flamingo-Cursors.zip  -> ${P}-mocha-flamingo.zip
		${MY_URI}/${MY_MOCHA}-Green-Cursors.zip     -> ${P}-mocha-green.zip
		${MY_URI}/${MY_MOCHA}-Lavender-Cursors.zip  -> ${P}-mocha-lavender.zip
		${MY_URI}/${MY_MOCHA}-Maroon-Cursors.zip    -> ${P}-mocha-maroon.zip
		${MY_URI}/${MY_MOCHA}-Mauve-Cursors.zip     -> ${P}-mocha-mauve.zip
		${MY_URI}/${MY_MOCHA}-Peach-Cursors.zip     -> ${P}-mocha-peach.zip
		${MY_URI}/${MY_MOCHA}-Pink-Cursors.zip      -> ${P}-mocha-pink.zip
		${MY_URI}/${MY_MOCHA}-Red-Cursors.zip       -> ${P}-mocha-red.zip
		${MY_URI}/${MY_MOCHA}-Rosewater-Cursors.zip -> ${P}-mocha-rosewater.zip
		${MY_URI}/${MY_MOCHA}-Sapphire-Cursors.zip  -> ${P}-mocha-sapphire.zip
		${MY_URI}/${MY_MOCHA}-Sky-Cursors.zip       -> ${P}-mocha-sky.zip
		${MY_URI}/${MY_MOCHA}-Teal-Cursors.zip      -> ${P}-mocha-teal.zip
		${MY_URI}/${MY_MOCHA}-Yellow-Cursors.zip    -> ${P}-mocha-yellow.zip
	)
"
S="${WORKDIR}"

IUSE="+frappe latte macchiato mocha"
REQUIRED_USE="|| ( frappe latte macchiato mocha )"

BDEPEND="
	app-arch/unzip
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	insinto "/usr/share/icons"
	for folder in * ; do
		if [ -d "${folder}" ]; then
			doins -r "${folder}"
		fi
	done
}
