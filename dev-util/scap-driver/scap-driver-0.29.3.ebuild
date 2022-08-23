# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-mod

DESCRIPTION="Kernel module for dev-util/sysdig"
HOMEPAGE="https://sysdig.com/"

# The driver is part of falcosecurity/libs, but for versioning reasons we cannot (yet)
# use semver-released packages; instead we pull in a commit that is used and known
# to work with sysdig, see sysdig/cmake/modules/falcosecurity-libs.cmake for details.
# For now the commit here and the one referenced in sysdig should be in sync.
LIBS_COMMIT="e5c53d648f3c4694385bbe488e7d47eaa36c229a"
SRC_URI="https://github.com/falcosecurity/libs/archive/${LIBS_COMMIT}.tar.gz -> falcosecurity-libs-${LIBS_COMMIT}.tar.gz"
S="${WORKDIR}/libs-${LIBS_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="!<dev-util/sysdig-${PV}[modules]"

CONFIG_CHECK="HAVE_SYSCALL_TRACEPOINTS ~TRACEPOINTS"

PATCHES=( "${FILESDIR}"/${PV}-fix-kmod-build-on-5.18+.patch )

src_configure() {
	local mycmakeargs=(
		# we will use linux-mod, so just pretend to use bundled deps
		# in order to make it through the cmake setup.
		-DUSE_BUNDLED_DEPS=ON
		-DCREATE_TEST_TARGETS=OFF
		-DDRIVER_VERSION=${LIBS_COMMIT}
	)

	cmake_src_configure

	# setup linux-mod ugliness
	MODULE_NAMES="scap(extra:${BUILD_DIR}/driver/src:)"
	BUILD_PARAMS='KERNELDIR="${KERNEL_DIR}"'
	# work with clang-built kernels (#816024)
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
