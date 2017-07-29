# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Laretz sync server"
HOMEPAGE="https://leechcraft.org"

EGIT_REPO_URI="https://github.com/0xd34df00d/laretz.git"
EGIT_PROJECT="laretz"

inherit cmake-utils git-r3

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/boost
		~app-leechcraft/liblaretz-${PV}
		dev-db/mongodb"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}"/src/server
