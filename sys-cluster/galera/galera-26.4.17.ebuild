# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="${PN}-4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Synchronous multi-master replication engine that provides the wsrep API"
HOMEPAGE="https://galeracluster.com"
SRC_URI="
	https://releases.galeracluster.com/${MY_PN}.$(ver_cut 3)/source/${MY_P}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ppc64 ~x86"
IUSE="garbd ssl"

RDEPEND="
	ssl? ( dev-libs/openssl:= )
	dev-libs/boost:=
"
# TODO: Make check dep optional
DEPEND="
	${RDEPEND}
	>=dev-cpp/asio-1.22
	dev-libs/check
"

src_prepare() {
	cmake_src_prepare

	# Remove bundled dev-cpp/asio
	rm -r asio || die "Failed to remove bundled asio"

	# Remove optional garbd daemon
	if ! use garbd ; then
		rm -r garb || die "Failed to remove garbd daemon"
		sed -i '/add_subdirectory(garb)/d' CMakeLists.txt || die
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
