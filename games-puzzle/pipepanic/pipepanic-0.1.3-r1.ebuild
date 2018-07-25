# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A simple pipe connecting game"
HOMEPAGE="http://www.users.waitrose.com/~thunor/pipepanic/"
SRC_URI="http://www.users.waitrose.com/~thunor/pipepanic/dload/${P}-source.tar.gz"

LICENSE="GPL-2 FreeArt"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[video]"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-source"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-gentoo.patch
	# change harcoded data paths to match the install directory
	sed -i \
		-e "s:/opt/QtPalmtop/share/pipepanic/:/usr/share/${PN}/:" \
		main.h \
		|| die "sed failed"
}

src_install() {
	dobin "${PN}"

	insinto "/usr/share/${PN}"
	doins *.bmp
	newicon PipepanicIcon64.png ${PN}.png
	make_desktop_entry ${PN} "Pipepanic"
	einstalldocs
}
