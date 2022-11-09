# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="A drawing tool for 2D molecular structures"
HOMEPAGE="http://molsketch.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/Molsketch/${P^}-src.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=sci-chemistry/openbabel-3:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.0-_DEFAULT_SOURCE.patch
)

src_configure() {
	local mycmakeargs=(
		# fix the doc dir, this is relative to the install dir (i.e. /usr/)
		-DMSK_INSTALL_DOCS="/share/doc/${PF}"
	)
	cmake_src_configure
}
