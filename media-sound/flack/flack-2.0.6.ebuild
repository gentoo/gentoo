# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="edit FLAC tags from command line"
HOMEPAGE="https://sourceforge.net/projects/flack/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-3.2
	>=media-libs/flac-1.2.1"

src_install() {
	dobin flack
	insinto etc
	doins flackrc
	dodoc ChangeLog README
}
