# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
