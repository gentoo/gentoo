# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python2_7 )

inherit python-r1 cmake-utils pax-utils check-reqs

MY_P=${PN}-enterprise-${PV}

DESCRIPTION="An open source, high-performance distribution of MongoDB"
HOMEPAGE="https://www.percona.com/software/mongo-database/percona-tokumx"
SRC_URI="https://www.percona.com/downloads/percona-tokumx/${MY_P}/source/tarball/${MY_P}.tar.gz"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pax_kernel"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/jemalloc
	!dev-libs/mongo-cxx-driver
	>=dev-libs/boost-1.50[threads(+)]
	>=dev-libs/libpcre-8.30[cxx]
	net-libs/libpcap"
DEPEND="${RDEPEND}
	dev-util/valgrind
	sys-libs/ncurses
	sys-libs/readline
	pax_kernel? ( sys-apps/paxctl sys-apps/elfix )
"

S="${WORKDIR}/${MY_P}"
QA_PRESTRIPPED="/usr/lib64/libHotBackup.so"
CHECKREQS_DISK_BUILD="13G"

src_prepare() {
	eapply "${FILESDIR}/${P}-no-werror.patch"
	eapply "${FILESDIR}/${P}-boost-57.patch"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTOKU_DEBUG_PARANOID=OFF
		-DUSE_VALGRIND=OFF
		-DUSE_BDB=OFF
		-DBUILD_TESTING=OFF
		-DTOKUMX_DISTNAME=${PV}
		-DLIBJEMALLOC="jemalloc"
		-DTOKUMX_STRIP_BINARIES=0
		-DUSE_SYSTEM_PCRE=1
		-DUSE_SYSTEM_BOOST=1
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
