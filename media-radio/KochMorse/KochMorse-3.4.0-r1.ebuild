# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Morse-code tutor using the Koch method"
HOMEPAGE="https://github.com/hmatuschek/kochmorse"
SRC_URI="https://github.com/hmatuschek/kochmorse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="dev-qt/linguist-tools:5"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}"

S="${WORKDIR}/kochmorse-${PV}"

src_prepare() {
	cmake_src_prepare
	# Upstream uses a non-standard category in release 3.4.0. I submitted
	# a fix which has been accepted, but not yet released.
	sed -i -e 's/Teaching;/X-Teaching;/' shared/kochmorse.desktop || die
}
