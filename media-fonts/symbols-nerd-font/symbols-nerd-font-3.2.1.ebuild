# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: no interest in supporting building or packaging the full suite of
# fonts, only quickly added because x11-terms/kitty requires it -- if a
# Gentoo dev wants more, feel free to take over maintenance and re-arrange.

FONT_SUFFIX=ttf
inherit font

DESCRIPTION="Symbols-only font containing the Nerd Font icons"
HOMEPAGE="https://www.nerdfonts.com/"
SRC_URI="
	https://github.com/ryanoasis/nerd-fonts/releases/download/v${PV}/NerdFontsSymbolsOnly.zip
		-> ${P}.zip
"
S=${WORKDIR}

LICENSE="MIT"
SLOT="0"
# Unkeyworded for now given unsure if will be keeping this package until kitty
# makes a release and still requires it (reserving to drop without last-rite).
#
# If used, will match keywords with kitty not to bother arch teams over an
# allarches package that just copies prebuilt fonts.
#KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND="app-arch/unzip"
