# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-mod-r1

DESCRIPTION="Kernel module for dev-debug/sysdig"
HOMEPAGE="https://sysdig.com/"
SRC_URI="https://github.com/falcosecurity/libs/archive/${PV}.tar.gz -> falcosecurity-libs-${PV}.tar.gz"
S="${WORKDIR}/libs-${PV}"

LICENSE="Apache-2.0 GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="!<dev-debug/sysdig-${PV}[modules]"

CONFIG_CHECK="HAVE_SYSCALL_TRACEPOINTS ~TRACEPOINTS"

# We need to specify the driver version manually since we do not use a git tree.
# This version can be found as git tag on the same commit as the libs version.
DRIVER_VERSION="7.3.0+driver"

src_configure() {
	local mycmakeargs=(
		# we will use linux-mod, so just pretend to use bundled deps
		# in order to make it through the cmake setup.
		-DUSE_BUNDLED_DEPS=ON
		-DCREATE_TEST_TARGETS=OFF
		-DDRIVER_VERSION="${DRIVER_VERSION}"
	)

	cmake_src_configure
}

src_compile() {
	local modlist=( scap=:"${BUILD_DIR}"/driver/src )
	local modargs=( KERNELDIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}
