# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/tokumx/tokumx-1.5.0.ebuild,v 1.1 2014/08/01 13:08:05 chainsaw Exp $

EAPI=5
CMAKE_BUILD_TYPE=Release

inherit cmake-utils

MY_P=${PN}-git-tag-${PV}

DESCRIPTION="An open source, high-performance distribution of MongoDB"
HOMEPAGE="http://www.tokutek.com/products/tokumx-for-mongodb/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	!dev-libs/jemalloc
	>=dev-libs/boost-1.50[threads(+)]
	>=dev-libs/libpcre-8.30[cxx]
	net-libs/libpcap"
DEPEND="${RDEPEND}
	sys-libs/ncurses
	sys-libs/readline"

S="${WORKDIR}/mongo"
BUILD_DIR="${WORKDIR}/mongo/build"
QA_PRESTRIPPED="/usr/lib64/libHotBackup.so"

src_prepare() {
	epatch "${FILESDIR}/${PV}-Werror.diff"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-D TOKU_DEBUG_PARANOID=OFF
		-D USE_VALGRIND=OFF
		-D USE_BDB=OFF
		-D BUILD_TESTING=OFF
		-D TOKUMX_DISTNAME=${PV}
	)
	cmake-utils_src_configure
}
