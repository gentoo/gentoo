# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="LucenePlusPlus-rel_${PV}"
inherit cmake-utils multilib

DESCRIPTION="C++ port of Java Lucene library, a high-performance, full-featured text search engine"
HOMEPAGE="https://github.com/luceneplusplus/LucenePlusPlus"
SRC_URI="https://github.com/luceneplusplus/LucenePlusPlus/archive/rel_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-3 Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/boost:="
RDEPEND="${DEPEND}"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS README.rst )

PATCHES=(
	"${FILESDIR}/${P}-disable-demos.patch"
	"${FILESDIR}/${P}-disable-tests.patch"
	"${FILESDIR}/${P}-fix-installing-headers.patch"
)

src_configure() {
	local mycmakeargs=(
		-DLIB_DESTINATION=$(get_libdir)
	)
	cmake-utils_src_configure
}
