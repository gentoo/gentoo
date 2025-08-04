# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit bash-completion-r1 cmake flag-o-matic linux-info lua-single

DESCRIPTION="A system exploration and troubleshooting tool"
HOMEPAGE="https://www.sysdig.com/"

# The version of falcosecurity-libs required by sysdig as source tree
LIBS_VERSION="0.20.0"
LIBS="falcosecurity-libs-${LIBS_VERSION}"

SRC_URI="https://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/falcosecurity/libs/archive/${LIBS_VERSION}.tar.gz -> ${LIBS}.tar.gz"

# The driver version as found in cmake/modules/driver.cmake or alternatively
# as git tag on the $LIBS_VERSION of falcosecurity-libs.
DRIVER_VERSION="8.0.0+driver"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="bpf +modules"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-cpp/abseil-cpp:=
	dev-cpp/tbb:=
	dev-cpp/yaml-cpp:=
	dev-libs/jsoncpp:=
	dev-libs/libb64:=
	bpf? ( >=dev-libs/libbpf-1.1:= )
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

BDEPEND="bpf? (
			dev-util/bpftool
			llvm-core/clang:*[llvm_targets_BPF]
		)"

# pin the driver to the falcosecurity-libs version
PDEPEND="modules? ( =dev-debug/scap-driver-${LIBS_VERSION}* )"

PATCHES=(
	"${FILESDIR}/0.38.1-scap-loader.patch"
)

pkg_pretend() {
	if use bpf; then
		local CONFIG_CHECK="
			~BPF
			~BPF_EVENTS
			~BPF_JIT
			~BPF_SYSCALL
			~FTRACE_SYSCALLS
			~HAVE_EBPF_JIT
		"
		check_extra_config
	fi
}

src_prepare() {
	# manually apply patches to falcosecurity-libs
	pushd "${WORKDIR}/libs-${LIBS_VERSION}"
		eapply "${FILESDIR}/libs-0.20.0-fix-buffer-overrun-reading-sockets-from-procfs.patch" || die
		eapply "${FILESDIR}/libs-0.20.0-fix-driver-and-bpf-makefile-for-kernel-6.13.patch" || die
		eapply "${FILESDIR}/libs-0.20.0-fix-INET6_ADDRSTRLEN-buffer-size.patch" || die
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
		-DENABLE_DKMS=OFF

		# disable all test targets
		-DCREATE_TEST_TARGETS=OFF

		# libscap examples are not installed or really useful
		-DBUILD_LIBSCAP_EXAMPLES=OFF

		# do not build internal libs as shared
		-DBUILD_SHARED_LIBS=OFF

		# build modern BPF probe depending on USE
		-DBUILD_SYSDIG_MODERN_BPF=$(usex bpf)

		# set driver location/version
		-DDRIVER_SOURCE_DIR="${WORKDIR}"/libs-${LIBS_VERSION}/driver
		-DDRIVER_VERSION=${DRIVER_VERSION}

		# point sysdig to the libs tree
		-DUSE_BUNDLED_FALCOSECURITY_LIBS=ON
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

pkg_postinst() {
	if use bpf; then
		elog
		elog "You have enabled the 'modern BPF' probe."
		elog "This eBPF-based event source is an alternative to the traditional"
		elog "scap kernel module."
		elog
		elog "To use it, start sysdig/csysdig with '--modern-bpf'."
		elog
	fi
}
