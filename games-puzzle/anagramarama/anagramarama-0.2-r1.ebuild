# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop vcs-clean

DESCRIPTION="Create as many words as you can before the time runs out"
HOMEPAGE="http://www.coralquest.com/anagramarama/"
SRC_URI="http://www.omega.clara.net/anagramarama/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2"
RDEPEND="${DEPEND}
	sys-apps/miscfiles
"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	ecvs_clean
	sed -i \
		-e "s:wordlist.txt:/usr/share/${PN}/wordlist.txt:" \
		-e "s:audio/:/usr/share/${PN}/audio/:" \
		-e "s:images/:/usr/share/${PN}/images/:" \
		src/{ag.c,dlb.c} \
		|| die "sed failed"
	eapply "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	newbin ag ${PN}
	insinto "/usr/share/${PN}"
	doins wordlist.txt
	doins -r images/ audio/
	dodoc readme
	make_desktop_entry ${PN} "Anagramarama"
}
