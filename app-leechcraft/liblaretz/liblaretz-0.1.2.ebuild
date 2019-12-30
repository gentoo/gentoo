# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Shared library to be used by the Laretz sync server and its clients"
HOMEPAGE="https://leechcraft.org"
SRC_URI="https://github.com/0xd34df00d/${PN#lib}/archive/${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN#lib}-${PV}"
CMAKE_USE_DIR="${S}"/src/lib
