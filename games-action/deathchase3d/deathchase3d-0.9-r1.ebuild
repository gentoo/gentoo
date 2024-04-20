# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Remake of the Sinclair Spectrum game of the same name"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/libsdl[video]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-underlink.patch"
)

src_install() {
	dobin ${PN}/${PN}
	dodoc README ${PN}/docs/en/index.html

	make_desktop_entry ${PN} "Death Chase 3D" applications-games
}
