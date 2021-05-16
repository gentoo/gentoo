# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop eutils

DESCRIPTION="Beneath a Steel Sky: a SciFi thriller set in a bleak vision of the future"
#HOMEPAGE="http://www.revgames.com/_display.php?id=16"
HOMEPAGE="https://en.wikipedia.org/wiki/Beneath_a_Steel_Sky"
SRC_URI="http://downloads.sourceforge.net/scummvm/BASS-Floppy-${PV}.zip
	mirror://gentoo/${PN}.png"

LICENSE="bass"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RDEPEND=">=games-engines/scummvm-0.5.0"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/"

src_install() {
	make_wrapper bass "scummvm -f -p \"/usr/share/${PN}\" -q\$(scummvmGetLang.sh) sky" .
	dobin "${FILESDIR}"/scummvmGetLang.sh
	insinto /usr/share/${PN}
	doins sky.*
	dodoc readme.txt
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Beneath a Steel Sky"
}
