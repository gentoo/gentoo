# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/i-rinat/fragview.git"
else
	SRC_URI="https://github.com/i-rinat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Disk fragmentation visualizer based on FIEMAP and FIBMAP ioctls"
HOMEPAGE="https://github.com/i-rinat/fragview"

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-db/sqlite:3
	dev-libs/boost:=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-linking.patch" )
