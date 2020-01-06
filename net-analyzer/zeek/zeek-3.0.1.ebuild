# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-utils python-single-r1

DESCRIPTION="The Zeek Network Security Monitor"
HOMEPAGE="https://www.zeek.org"
SRC_URI="https://www.zeek.org/downloads/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl debug geoipv2 ipsumdump ipv6 jemalloc kerberos +python sendmail \
	static-libs tcmalloc +tools +zeekctl"

RDEPEND=">=sys-libs/glibc-2.10
	curl? ( net-misc/curl )
	dev-libs/actor-framework
	dev-libs/openssl:0
	geoipv2? ( dev-libs/libmaxminddb )
	ipsumdump? ( net-analyzer/ipsumdump[ipv6?] )
	jemalloc? ( dev-libs/jemalloc )
	kerberos? ( virtual/krb5 )
	net-libs/libpcap
	python? ( ${PYTHON_DEPS}
		dev-python/pybind11[${PYTHON_USEDEP}] )
	sendmail? ( virtual/mta )
	sys-libs/zlib
	tcmalloc? ( dev-util/google-perftools )"

DEPEND="${RDEPEND}"

BDEPEND=">=dev-lang/swig-3.0
	>=dev-util/cmake-2.8.12
	>=sys-devel/bison-2.5
	>=sys-devel/gcc-4.8
	sys-devel/flex"

REQUIRED_USE="zeekctl? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${PN}-no-wrapper-scripts.patch
	"${FILESDIR}"/${PN}-no-strip.patch
	"${FILESDIR}"/${PN}-no-uninitialized-warning.patch
)

src_prepare() {
	rm -rf aux/broker/3rdparty/caf || die
	rm -rf aux/broker/bindings/python/3rdparty || die
	rm -rf src/3rdparty/caf || die

	if use python; then
		sed -i 's:.*/3rdparty/pybind11/.*:if(DISABLE_PYTHON_BINDINGS):' \
			aux/broker/CMakeLists.txt || die
		sed -i 's:.*/3rdparty/pybind11/.*::' \
			aux/broker/bindings/python/CMakeLists.txt || die
	fi

	if ! use static-libs; then
		sed -i 's:add_library(paraglob STATIC:add_library(paraglob SHARED:' \
		aux/paraglob/src/CMakeLists.txt
		sed -i 's:DESTINATION lib:DESTINATION ${INSTALL_LIB_DIR}:' \
		aux/paraglob/src/CMakeLists.txt
	fi

	sed -i 's:if (LIBMMDB_FOUND):if (LIBMMDB_FOUND AND ENABLE_MMDB):' \
		-i CMakeLists.txt || die

	sed -i 's:  if (LIBKRB5_FOUND):  if (LIBKRB5_FOUND AND ENABLE_KRB5):' \
		-i CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DCAF_ROOT_DIR="${EPREFIX}/usr/include/caf"
		-DENABLE_DEBUG=$(usex debug)
		-DENABLE_JEMALLOC=$(usex jemalloc)
		-DENABLE_KRB5=$(usex kerberos)
		-DENABLE_MMDB=$(usex geoipv2)
		-DENABLE_PERFTOOLS=$(usex tcmalloc)
		-DENABLE_STATIC=$(usex static-libs)
		-DBUILD_STATIC_BROKER=$(usex static-libs)
		-DBUILD_STATIC_BINPAC=$(usex static-libs)
		-DINSTALL_ZEEKCTL=$(usex zeekctl)
		-DINSTALL_AUX_TOOLS=$(usex tools)
		-DENABLE_MOBILE_IPV6=$(usex ipv6)
		-DDISABLE_PYTHON_BINDINGS=$(usex python no yes)
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DZEEK_ETC_INSTALL_DIR="/etc/${PN}"
		-DINSTALL_LIB_DIR="/usr/$(get_libdir)"
		-DPY_MOD_INSTALL_DIR="$(python_get_sitedir)"
		-DBINARY_PACKAGING_MODE=true
	)

	use debug && use tcmalloc && mycmakeargs+=( -DENABLE_PERFTOOLS_DEBUG=yes )
	use python && mycmakeargs+=( -DPYTHON_CONFIG="${PYTHON}-config" )
	use zeekctl && mycmakeargs+=(
		-DZEEK_LOG_DIR="/var/log/${PN}"
		-DZEEK_SPOOL_DIR="/var/spool/${PN}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	python_optimize

	keepdir /var/log/"${PN}" /var/spool/"${PN}"/tmp

	# Doesn't exist
	rm -f "${ED}"/var/spool/zeek/zeekctl-config.sh
	rm -f "${ED}"/usr/share/zeekctl/scripts/zeekctl-config.sh

	# Remove compat symlinks
	rm -f "${ED}"/usr/bin/broctl "${ED}"/usr/lib/broctl
}
