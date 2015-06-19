# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/express/express-0.9.5.ebuild,v 1.3 2012/11/09 14:39:17 jlec Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="Streaming RNA-Seq Analysis"
HOMEPAGE="http://bio.math.berkeley.edu/eXpress/"
SRC_URI="http://bio.math.berkeley.edu/eXpress/downloads/express-${PV}/express-${PV}-src.tgz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/boost
	sys-libs/zlib
	sci-biology/bamtools"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src"

CMAKE_USE_DIR="${S}/src"

src_prepare() {
	sed \
		-e 's|"${CMAKE_CURRENT_SOURCE_DIR}/../bamtools/lib/libbamtools.a"|bamtools|' \
		-e '1 a find_package(Boost 1.46 COMPONENTS filesystem program_options thread)' \
		-e '1 a find_package(ZLIB)' \
		-e '/add_executable/ a include_directories("/usr/include/bamtools")' \
		-i src/CMakeLists.txt || die
}
