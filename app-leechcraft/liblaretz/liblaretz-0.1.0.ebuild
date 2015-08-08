# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Shared library to be used by the Laretz sync server and its clients"
HOMEPAGE="http://leechcraft.org"
SRC_URI="https://github.com/0xd34df00d/${PN#lib}/archive/${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake-utils

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN#lib}-${PV}"
CMAKE_USE_DIR="${S}"/src/lib
