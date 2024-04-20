# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PAK_CS_128="pak128.CS-r2096.zip"
MY_PAK_GERMAN_128="PAK128.german_2.1_for_ST_123.0.zip"
MY_PAK_128="simupak128-2.8.2-for123.zip"

DESCRIPTION="PakSets (scenario data) for games-simulation/simutrans"
HOMEPAGE="https://www.simutrans.com/paksets/"
SRC_URI="
	128? ( mirror://sourceforge/simutrans/${MY_PAK_128} -> simutrans_${MY_PAK_128} )
	comic192? ( https://github.com/Flemmbrav/Pak192.Comic/releases/download/2021-V0.6-RC2/pak192.comic.0.6.RC2.zip -> simutrans_pak192.comic.0.6.RC2.zip )
	cs128? ( mirror://sourceforge/simutrans/${MY_PAK_CS_128} -> simutrans_${MY_PAK_CS_128} )
	german128? ( mirror://sourceforge/simutrans/${MY_PAK_GERMAN_128} -> simutrans_${MY_PAK_GERMAN_128} )
	nippon64? ( https://github.com/wa-st/pak-nippon/releases/download/v0.5.0/pak.nippon-v0.5.0.zip -> simutrans_pak.nippon-v0.5.0.zip )
	excentrique48? ( https://github.com/Varkalandar/pak48.Excentrique/releases/download/v0.19_RC3/pak48.excentrique_v019rc3.zip -> simutrans_pak48.excentrique_v019rc3.zip )
"
S="${WORKDIR}"

LICENSE="
	128? ( Artistic-2 )
	comic192? ( CC-BY-SA-3.0 )
	cs128? ( Artistic-2 )
	excentrique48? ( CC-BY-SA-4.0 )
	german128? ( PAK128.German )
	nippon64? ( MIT )
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+128 comic192 cs128 excentrique48 german128 nippon64"
REQUIRED_USE="|| ( 128 comic192 cs128 excentrique48 german128 nippon64 )"

RDEPEND="!<games-simulation/simutrans-123.0"
BDEPEND="app-arch/unzip"

src_prepare() {
	default

	# Only 128 and german128 have a simutrans/ folder.
	if [[ -d simutrans ]]; then
		mv simutrans/* . || die
		rmdir simutrans || die
	fi

	if use comic192; then
		mv pak192.comic-nightly-datconverter pak192.comic || die
	fi
}

src_install() {
	insinto usr/share/simutrans
	doins -r *
}
