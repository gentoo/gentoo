# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="A GUI frontend to gdb"
HOMEPAGE="https://github.com/epasveer/seer"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/epasveer/seer"
	inherit git-r3
else
	SRC_URI="https://github.com/epasveer/seer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

S="${WORKDIR}"/${P}/src

# Upstream keep 'debian/copyright' up to date
# https://github.com/epasveer/seer/issues/86
LICENSE="GPL-3+ CC-BY-3.0 CC-BY-4.0"
SLOT="0"

DEPEND="
	dev-qt/qtcharts:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
"
RDEPEND="
	${DEPEND}
	sys-devel/gdb
"

PATCHES=(
	"${FILESDIR}"/${P}-build-fixes.patch
)

src_install() {
	cmake_src_install

	domenu resources/seergdb.desktop

	local size
	for size in 32 64 128 256 512 ; do
		newicon -s ${size} resources/seergdb_${size}x${size}.png seergdb.png
	done
}
