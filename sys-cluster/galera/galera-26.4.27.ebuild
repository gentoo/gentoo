# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MARIADB_VERSION="10.11.18"

DESCRIPTION="Synchronous multi-master replication engine that provides the wsrep API"
HOMEPAGE="https://mariadb.com/products/enterprise/galera-cluster/"
SRC_URI="https://archive.mariadb.org/mariadb-${MARIADB_VERSION}/${P}/src/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 x86"
IUSE="garbd ssl"

RDEPEND="
	ssl? ( dev-libs/openssl:= )
	dev-libs/boost:=
"
# TODO: Make check dep optional
DEPEND="
	${RDEPEND}
	>=dev-cpp/asio-1.22
	<dev-cpp/asio-1.33
	dev-libs/check
"

# Skip false positive QA Notice for wsrep/src/CMakeLists.txt, which is not used
# in this package. Galera uses wsrep/src only as a include directory.
CMAKE_QA_COMPAT_SKIP=1

src_prepare() {
	cmake_src_prepare

	# Remove bundled dev-cpp/asio
	rm -r asio || die "Failed to remove bundled asio"

	# Remove optional garbd daemon
	if ! use garbd ; then
		rm -r garb || die "Failed to remove garbd daemon"
		cmake_comment_add_subdirectory garb
	fi
}

src_configure() {
	local mycmakeargs=(
		-DGALERA_WITH_SSL=$(usex ssl)
	)

	cmake_src_configure
}

src_install() {
	dodoc scripts/packages/README scripts/packages/README-MySQL

	if use garbd ; then
		newconfd "${FILESDIR}"/garb.cnf garbd
		newinitd "${FILESDIR}"/garb.init garbd
		doman man/garbd.8

		pushd "${BUILD_DIR}" || die
		dobin garb/garbd
	fi

	pushd "${BUILD_DIR}" || die
	exeinto /usr/$(get_libdir)/galera
	doexe libgalera_smm.so
}
