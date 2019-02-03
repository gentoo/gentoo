# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=JRomManager
MY_PV=${PV/_p/b}
MY_P="${MY_PN}-${MY_PV}"

inherit desktop

DESCRIPTION="A Mame and Retrogaming Rom Manager, Java alternative to ClrMamePro"
HOMEPAGE="https://github.com/optyfr/JRomManager"
SRC_URI="https://github.com/optyfr/${MY_PN}/releases/download/${MY_PV}/${MY_P}.zip"
QA_PREBUILT="*"

S="${WORKDIR}"

LICENSE="GPL-2 GPL-2-with-classpath-exception BSD-2 MIT Apache-2.0 LGPL-2.1 unRAR"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8"
DEPEND="${DEPEND}
	app-arch/unzip"

src_prepare() {
	default

	sed -e "/cd.*/s:.*:cd \"${EROOT}/usr/share/${PN}\" || exit:" -i *.sh || die "sed failed!"
	unzip -j ${MY_PN}.jar "jrm/resources/rom.png" || die
}

src_install() {
	insinto "/usr/share/${PN}"
	doins *.jar
	doins -r lib
	newbin "${MY_PN}-multi.sh" "${PN}"
	newicon "rom.png" "${PN}.png"
	make_desktop_entry "${PN}" '' '' 'Utility'
}
