# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULES_OPTIONAL_USE=modules
inherit linux-mod bash-completion-r1 cmake-utils

DESCRIPTION="A system exploration and troubleshooting tool"
HOMEPAGE="https://sysdig.com/"
SRC_URI="https://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0
	modules? ( || ( MIT GPL-2 ) )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl +modules"

RDEPEND="
	app-misc/jq:0=
	dev-cpp/tbb:0=
	dev-lang/luajit:2=
	>=dev-libs/jsoncpp-0.6_pre:0=
	dev-libs/libb64:0=
	dev-libs/protobuf:0=
	net-dns/c-ares:0=
	net-libs/grpc:0=
	sys-libs/ncurses:0=
	sys-libs/zlib:0=
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	net-misc/curl:0="
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/os-headers"

# needed for the kernel module
CONFIG_CHECK="HAVE_SYSCALL_TRACEPOINTS ~TRACEPOINTS"

pkg_pretend() {
	linux-mod_pkg_setup
}

pkg_setup() {
	linux-mod_pkg_setup
}

src_prepare() {
	sed -i -e 's:-ggdb::' CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# we will use linux-mod for that
		-DBUILD_DRIVER=OFF
		# libscap examples are not installed or really useful
		-DBUILD_LIBSCAP_EXAMPLES=OFF

		# unbundle the deps
		-DUSE_BUNDLED_DEPS=OFF
	)

	cmake-utils_src_configure

	# setup linux-mod ugliness
	MODULE_NAMES="sysdig-probe(extra:${BUILD_DIR}/driver/src:)"
	BUILD_PARAMS='KERNELDIR="${KERNEL_DIR}"'
	BUILD_TARGETS="all"
}

src_compile() {
	cmake-utils_src_compile
	linux-mod_src_compile
}

src_install() {
	cmake-utils_src_install
	linux-mod_src_install

	# remove sources
	rm -r "${ED}"/usr/src || die

	# move bashcomp to the proper location
	dobashcomp "${ED}"/usr/etc/bash_completion.d/sysdig || die
	rm -r "${ED}"/usr/etc || die
}
