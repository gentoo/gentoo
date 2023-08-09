# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-mod-r1

MY_P=${P/-kmod}
DESCRIPTION="Kernel module for dev-util/sysdig"
HOMEPAGE="https://sysdig.com/"
SRC_URI="https://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="|| ( MIT GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PV}-fix-kmod-build-on-5.18+.patch
)

CONFIG_CHECK="HAVE_SYSCALL_TRACEPOINTS ~TRACEPOINTS"

src_prepare() {
	cmake_src_prepare

	# cmake is only used to generate the Makefile for modules
	sed -i '/USE_BUNDLED_DEPS/,$d' CMakeLists.txt || die
}

src_compile() {
	local modlist=( sysdig-probe=:"${BUILD_DIR}"/driver/src )
	local modargs=( KERNELDIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}
