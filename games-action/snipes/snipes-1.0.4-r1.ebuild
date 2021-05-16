# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop toolchain-funcs

DESCRIPTION="2D scrolling shooter, resembles the old DOS game of same name"
HOMEPAGE="https://cyp.github.com/snipes/"
SRC_URI="https://cyp.github.com/snipes/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-nongnulinker.patch
)

src_compile() {
	tc-getLD
	default
}

src_install() {
	dobin snipes
	doman snipes.6
	dodoc ChangeLog
	doicon ${PN}.png
	make_desktop_entry snipes "Snipes"
}
