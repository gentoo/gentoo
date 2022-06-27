# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

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

COMMON_DEPEND="
	dev-cpp/atkmm:0
	dev-cpp/cairomm:0
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libsigc++:2
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-linking.patch" )
