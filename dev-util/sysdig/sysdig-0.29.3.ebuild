# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit bash-completion-r1 cmake lua-single

DESCRIPTION="A system exploration and troubleshooting tool"
HOMEPAGE="https://sysdig.com/"

# For now we need to bump this version of falcosecurity/libs manually;
# check the used git revision in <src>/cmake/modules/falcosecurity-libs.cmake
LIBS_COMMIT="e5c53d648f3c4694385bbe488e7d47eaa36c229a"

SRC_URI="https://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/falcosecurity/libs/archive/${LIBS_COMMIT}.tar.gz -> falcosecurity-libs-${LIBS_COMMIT}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+modules"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	app-misc/jq
	dev-cpp/tbb:=
	dev-cpp/yaml-cpp:=
	dev-libs/libb64:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	net-dns/c-ares:=
	net-libs/grpc:=
	net-misc/curl
	sys-libs/ncurses:=
	sys-libs/zlib:="

DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
	dev-cpp/valijson
	virtual/os-headers"

# for now pin the driver to the same ebuild version
PDEPEND="modules? ( =dev-util/scap-driver-${PV}* )"

src_prepare() {
	sed -i -e 's:-ggdb::' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# don't build driver
		-DBUILD_DRIVER=OFF

		# libscap examples are not installed or really useful
		-DBUILD_LIBSCAP_EXAMPLES=OFF

		# point to the falcosecurity-libs tree
		-DFALCOSECURITY_LIBS_SOURCE_DIR="${WORKDIR}"/libs-${LIBS_COMMIT}

		# explicitly set version
		-DSYSDIG_VERSION=${PV}

		# unbundle the deps
		-DUSE_BUNDLED_DEPS=OFF

		# add valijson include path to prevent downloading
		-DVALIJSON_INCLUDE="${ESYSROOT}"/usr/include

		# enable chisels
		-DWITH_CHISEL=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# remove driver headers
	rm -r "${ED}"/usr/src || die

	# move bashcomp to the proper location
	dobashcomp "${ED}"/usr/etc/bash_completion.d/sysdig || die
	rm -r "${ED}"/usr/etc || die
}
