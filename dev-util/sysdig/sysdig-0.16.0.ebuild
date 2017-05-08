# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
MODULES_OPTIONAL_USE=modules
inherit linux-mod bash-completion-r1 cmake-utils

DESCRIPTION="A system exploration and troubleshooting tool"
HOMEPAGE="http://www.sysdig.org/"
SRC_URI="https://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+modules"

RDEPEND="
	app-misc/jq:0=
	dev-lang/luajit:2=
	>=dev-libs/jsoncpp-0.6_pre:0=
	dev-libs/libb64:0=
	sys-libs/ncurses:0=
	sys-libs/zlib:0=
	dev-libs/openssl:0=
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
	MODULE_NAMES="sysdig-probe(extra:${S}/driver:)"
	BUILD_PARAMS='KERNELDIR="${KERNEL_DIR}"'
	BUILD_TARGETS="all"

	if use modules; then
		cmake-utils_src_make configure_driver

		cp "${BUILD_DIR}"/driver/Makefile.dkms driver/Makefile || die
	fi
}

src_compile() {
	cmake-utils_src_compile

	linux-mod_src_compile
}

src_install() {
	cmake-utils_src_install

	linux-mod_src_install

	# remove sources
	rm -r "${ED%/}"/usr/src || die

	# move bashcomp to the proper location
	dobashcomp "${ED%/}"/usr/etc/bash_completion.d/sysdig || die
	rm -r "${ED%/}"/usr/etc || die
}
