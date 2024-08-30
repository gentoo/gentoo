# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit bash-completion-r1 cmake flag-o-matic lua-single

DESCRIPTION="A system exploration and troubleshooting tool"
HOMEPAGE="https://sysdig.com/"

# The version of falcosecurity-libs required by sysdig as source tree
LIBS_VERSION="0.17.3"
SRC_URI="https://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/falcosecurity/libs/archive/${LIBS_VERSION}.tar.gz -> falcosecurity-libs-${LIBS_VERSION}.tar.gz"

# The driver version as found in cmake/modules/driver.cmake
DRIVER_VERSION="7.2.0+driver"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+modules"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-cpp/abseil-cpp:=
	dev-cpp/tbb:=
	dev-cpp/yaml-cpp:=
	dev-libs/jsoncpp:=
	dev-libs/libb64:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	dev-libs/uthash
	net-libs/grpc:=
	net-misc/curl
	sys-libs/ncurses:=
	sys-libs/zlib:=
	virtual/libelf:="

DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
	dev-cpp/valijson
	virtual/os-headers"

# pin the driver to the falcosecurity-libs version
PDEPEND="modules? ( =dev-debug/scap-driver-${LIBS_VERSION}* )"

PATCHES=( "${FILESDIR}/${PV}-scap-loader.patch" )

src_prepare() {
	# manually apply patches to falcosecurity-libs dependency
	pushd "${WORKDIR}/libs-${LIBS_VERSION}"
		# musl has no libanl (#929227)
		if [ ${ELIBC} == "musl" ] ; then
			eapply "${FILESDIR}/${PV}-libs-no-libanl.patch" || die
		fi
	popd

	# do not build with debugging info
	sed -i -e 's/-ggdb//g' CMakeLists.txt "${WORKDIR}"/libs-${LIBS_VERSION}/cmake/modules/CompilerFlags.cmake || die

	# fix the driver version
	sed -i -e 's/0.0.0-local/${DRIVER_VERSION}/g' cmake/modules/driver.cmake || die

	cmake_src_prepare
}

src_configure() {
	# known problems with strict aliasing:
	# https://github.com/falcosecurity/libs/issues/1964
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		# do not build the kernel driver
		-DBUILD_DRIVER=OFF

		# libscap examples are not installed or really useful
		-DBUILD_LIBSCAP_EXAMPLES=OFF

		# do not build internal libs as shared
		-DBUILD_SHARED_LIBS=OFF

		# do not build eBPF driver for now
		-DBUILD_SYSDIG_MODERN_BPF=OFF

		# set driver version to prevent downloading (don't ask..)
		-DDRIVER_SOURCE_DIR="${WORKDIR}"/libs-${LIBS_VERSION}/driver
		-DDRIVER_VERSION=${DRIVER_VERSION}

		# point sysdig to the libs tree
		-DFALCOSECURITY_LIBS_SOURCE_DIR="${WORKDIR}"/libs-${LIBS_VERSION}

		# explicitly set sysdig version - required for some reason
		-DSYSDIG_VERSION=${PV}

		# do not use bundled dependencies for sysdig
		-DUSE_BUNDLED_DEPS=OFF

		# do not use bundled dependencies for falcosecurity-libs
		-DUSE_BUNDLED_B64=OFF
		-DUSE_BUNDLED_JSONCPP=OFF
		-DUSE_BUNDLED_RE2=OFF
		-DUSE_BUNDLED_TBB=OFF
		-DUSE_BUNDLED_VALIJSON=OFF

		# set valijson include path to prevent downloading
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

	# remove libscap/libsinsp headers & libs (see #938187)
	rm -r "${ED}"/usr/include/sysdig || die
	rm -r "${ED}"/usr/$(get_libdir) || die

	# move bashcomp to the proper location
	dobashcomp "${ED}"/usr/etc/bash_completion.d/sysdig || die
	rm -r "${ED}"/usr/etc || die
}
