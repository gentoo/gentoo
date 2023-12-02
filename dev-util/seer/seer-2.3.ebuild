# Copyright 2022-2023 Gentoo Authors
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
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtcharts:6
	dev-qt/qtsvg:6
"
RDEPEND="
	${DEPEND}
	sys-devel/gdb
"

src_configure() {
	local mycmakeargs=(
		# Upstream don't really support Qt 5 for >= 2.0:
		# https://github.com/epasveer/seer/wiki/Building-Seer---Qt5.
		-DQTVERSION=QT6
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	domenu resources/seergdb.desktop

	local size
	for size in 32 64 128 256 512 ; do
		newicon -s ${size} resources/seergdb_${size}x${size}.png seergdb.png
	done
}
