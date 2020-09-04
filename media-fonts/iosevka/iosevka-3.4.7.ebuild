# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

IUSE="extras"

DESCRIPTION="Slender typeface for code, from code"
HOMEPAGE="https://be5invis.github.io/Iosevka/"
SRC_URI="https://github.com/be5invis/${PN}/releases/download/v${PV}/ttf-${P}.zip
		 https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-term-${PV}.zip
extras? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-fixed-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-slab-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-term-slab-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-fixed-slab-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-curly-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-term-curly-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-fixed-curly-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-curly-slab-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-term-curly-slab-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-fixed-curly-slab-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-aile-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-etoile-${PV}.zip
		  https://github.com/be5invis/Iosevka/releases/download/v${PV}/ttf-${PN}-sparkle-${PV}.zip )"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_S="${S}/ttf"
FONT_SUFFIX="ttf"
