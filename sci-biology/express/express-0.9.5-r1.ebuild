# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/express/express-0.9.5-r1.ebuild,v 1.1 2014/02/05 07:33:57 pinkbyte Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Streaming RNA-Seq Analysis"
HOMEPAGE="http://bio.math.berkeley.edu/eXpress/"
SRC_URI="http://bio.math.berkeley.edu/eXpress/downloads/express-${PV}/express-${PV}-src.tgz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/boost-1.52.0:=
	sys-libs/zlib
	sci-biology/bamtools"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src"

CMAKE_USE_DIR="${S}/src"

src_prepare() {
	sed \
		-e 's|"${CMAKE_CURRENT_SOURCE_DIR}/../bamtools/lib/libbamtools.a"|bamtools|' \
		-e '1 a find_package(Boost 1.52 COMPONENTS filesystem program_options system thread)' \
		-e '1 a find_package(ZLIB)' \
		-e '/add_executable/ a include_directories("/usr/include/bamtools")' \
		-i src/CMakeLists.txt || die

	cmake-utils_src_prepare
}
