# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake linux-mod

MY_P=${P/-kmod}
DESCRIPTION="Kernel module for dev-util/sysdig"
HOMEPAGE="https://sysdig.com/"
SRC_URI="https://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="|| ( MIT GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!<=dev-util/sysdig-0.26.4[modules]"

CONFIG_CHECK="HAVE_SYSCALL_TRACEPOINTS ~TRACEPOINTS"

pkg_pretend() {
	linux-mod_pkg_setup
}

pkg_setup() {
	linux-mod_pkg_setup
}

src_prepare() {
	sed -i -e '/USE_BUNDLED_DEPS/,$d' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# we will use linux-mod for that
		-DBUILD_DRIVER=OFF
	)

	cmake_src_configure

	# setup linux-mod ugliness
	MODULE_NAMES="sysdig-probe(extra:${BUILD_DIR}/driver/src:)"
	BUILD_PARAMS='KERNELDIR="${KERNEL_DIR}"'

	# try to work with clang-built kernels (#816024)
	if linux_chkconfig_present CC_IS_CLANG; then
		BUILD_PARAMS+=' CC=${CHOST}-clang'
		if linux_chkconfig_present LD_IS_LLD; then
			BUILD_PARAMS+=' LD=ld.lld'
			if linux_chkconfig_present LTO_CLANG_THIN; then
				# kernel enables cache by default leading to sandbox violations
				BUILD_PARAMS+=' ldflags-y=--thinlto-cache-dir= LDFLAGS_MODULE=--thinlto-cache-dir='
			fi
		fi
	fi

	BUILD_TARGETS="all"
}
