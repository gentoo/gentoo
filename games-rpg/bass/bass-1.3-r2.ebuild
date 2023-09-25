# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Beneath a Steel Sky: a SciFi thriller set in a bleak vision of the future"
HOMEPAGE="https://en.wikipedia.org/wiki/Beneath_a_Steel_Sky"

CD_VERSION="1.2"
SRC_URI="http://downloads.sourceforge.net/scummvm/BASS-Floppy-${PV}.zip
	http://downloads.sourceforge.net/scummvm/bass-cd-${CD_VERSION}.zip
	mirror://gentoo/${PN}.png"
S="${WORKDIR}/"

LICENSE="bass"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND=">=games-engines/scummvm-0.5.0"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

src_install() {
	dobin "${FILESDIR}"/scummvmGetLang.sh

	insinto /usr/share/${PN}
	doins sky.*
	mv bass-cd-"${CD_VERSION}"/readme.txt readme-cd.txt || die
	doins -r bass-cd-"${CD_VERSION}"/

	make_wrapper bass "scummvm -f -n -p \"${EPREFIX}/usr/share/${PN}\" -q\$(scummvmGetLang.sh) sky" .
	make_wrapper bass-cd "scummvm -f -n -p \"${EPREFIX}/usr/share/${PN}/bass-cd-${CD_VERSION}\" -q\$(scummvmGetLang.sh) sky" .

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Beneath a Steel Sky (Floppy version)"
	make_desktop_entry ${PN}-cd "Beneath a Steel Sky (CD version)"

	dodoc readme*.txt
}
