# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Morse-code tutor using the Koch method"
HOMEPAGE="https://github.com/hmatuschek/kochmorse"
SRC_URI="https://github.com/hmatuschek/kochmorse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtmultimedia"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools
	dev-util/cmake[qt5]"

S="${WORKDIR}/kochmorse-${PV}"

src_prepare() {
	sed -i -e 's/Teaching;/X-Teaching;/' shared/kochmorse.desktop || die
	eapply_user
}
