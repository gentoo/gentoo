# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Slender typeface for code, from code"
HOMEPAGE="https://be5invis.github.io/Iosevka/"

SRC_URI="https://github.com/be5invis/Iosevka/releases/download/v${PV}/01-${P}.zip
	term? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/02-${PN}-term-${PV}.zip )
	type? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/03-${PN}-type-${PV}.zip )
	cc? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/04-${PN}-cc-${PV}.zip )
	slab? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/05-${PN}-slab-${PV}.zip )
	term-slab? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/06-${PN}-term-slab-${PV}.zip )
	type-slab? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/07-${PN}-type-slab-${PV}.zip )
	cc-slab? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/08-${PN}-cc-slab-${PV}.zip )
	experimental-aile? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/experimental-${PN}-aile-${PV}.zip )
	experimental-etoile? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/experimental-${PN}-etoile-${PV}.zip )
	experimental-extended? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/experimental-${PN}-extended-${PV}.zip )
	ss01? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss01-${PV}.zip )
	ss02? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss02-${PV}.zip )
	ss03? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss03-${PV}.zip )
	ss04? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss04-${PV}.zip )
	ss05? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss05-${PV}.zip )
	ss06? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss06-${PV}.zip )
	ss07? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss07-${PV}.zip )
	ss08? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss08-${PV}.zip )
	ss09? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss09-${PV}.zip )
	ss10? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss10-${PV}.zip )
	ss11? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-ss11-${PV}.zip )
	term-ss01? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss01-${PV}.zip )
	term-ss02? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss02-${PV}.zip )
	term-ss03? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss03-${PV}.zip )
	term-ss04? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss04-${PV}.zip )
	term-ss05? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss05-${PV}.zip )
	term-ss06? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss06-${PV}.zip )
	term-ss07? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss07-${PV}.zip )
	term-ss08? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss08-${PV}.zip )
	term-ss09? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss09-${PV}.zip )
	term-ss10? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss10-${PV}.zip )
	term-ss11? ( https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-term-ss11-${PV}.zip )
"

LICENSE="OFL-1.1"
SLOT="0"

IUSE="term type cc slab term-slab type-slab cc-slab
experimental-aile experimental-etoile experimental-extended
ss01 ss02 ss03 ss04 ss05 ss06 ss07 ss08 ss09 ss10 ss11
term-ss01 term-ss02 term-ss03 term-ss04 term-ss05 term-ss06
term-ss07 term-ss08 term-ss09 term-ss10 term-ss11"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_S="${S}/ttf"
FONT_SUFFIX="ttf"
