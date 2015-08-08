# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python2_7 )

inherit python-r1 cmake-utils pax-utils

MY_P=${PN}-git-tag-${PV}

DESCRIPTION="An open source, high-performance distribution of MongoDB"
HOMEPAGE="http://www.tokutek.com/products/tokumx-for-mongodb/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pax_kernel"

RDEPEND="
	dev-libs/jemalloc
	>=dev-libs/boost-1.50[threads(+)]
	>=dev-libs/libpcre-8.30[cxx]
	net-libs/libpcap"
DEPEND="${RDEPEND}
	sys-libs/ncurses
	sys-libs/readline
	pax_kernel? ( sys-apps/paxctl sys-apps/elfix )
"

S="${WORKDIR}/mongo"
BUILD_DIR="${WORKDIR}/mongo/build"
QA_PRESTRIPPED="/usr/lib64/libHotBackup.so"

src_prepare() {
	epatch "${FILESDIR}/${P}-no-werror.patch"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-D TOKU_DEBUG_PARANOID=OFF
		-D USE_VALGRIND=OFF
		-D USE_BDB=OFF
		-D BUILD_TESTING=OFF
		-D TOKUMX_DISTNAME=${PV}
		-D LIBJEMALLOC="jemalloc"
		-D TOKUMX_STRIP_BINARIES=0
		-D USE_SYSTEM_PCRE=1
		-D USE_SYSTEM_BOOST=1
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	pax-mark -m "${D}"/usr/bin/mongo

	# Remove unnecessary files
	rm -r "${D}usr/buildscripts" "${D}usr/scripts" "${D}usr/src" "${D}usr/include/db.h" || die

	# Correctly install this python script
	python_foreach_impl python_doscript scripts/tokumxstat.py

	# Clean up documentation installed to /usr
	pushd "${D}usr/" || die
	rm GNU-AGPL-3.0 LICENSE.txt NEWS README README.md README-TOKUDB README-TOKUKV SConstruct THIRD-PARTY-NOTICES || die
	popd || die
	dodoc README.md distsrc/NEWS distsrc/README distsrc/THIRD-PARTY-NOTICES
	newdoc src/third_party/ft-index/README-TOKUDB README-TOKUKV
}
