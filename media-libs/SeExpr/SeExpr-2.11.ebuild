# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="An embeddable expression evaluation engine"
HOMEPAGE="http://www.disneyanimation.com/technology/seexpr.html"

SRC_URI="https://github.com/wdas/SeExpr/archive/v2.11.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sys-devel/llvm:=
	media-libs/libpng:=
	virtual/opengl"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-build-fixes.patch" )

S="${WORKDIR}/SeExpr-${PV}"

src_configure() {
	local mycmakeargs=( $(cmake-utils_use_find_package doc Doxygen) )

	cmake-utils_src_configure
}
