# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CONFIG_CHECK="~!BATMAN_ADV ~LIBCRC32C ~CRC16"
MODULE_NAMES="${PN}(net:${S}/build/net/${PN}:${S}/build/net/${PN})"
BUILD_TARGETS="all"

inherit eutils linux-mod

DESCRIPTION="Better approach to mobile Ad-Hoc networking on layer 2 kernel module"
HOMEPAGE="https://www.open-mesh.org/"
SRC_URI="https://downloads.open-mesh.org/batman/releases/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bla dat debug nc mcast"

DEPEND=""
RDEPEND=""

src_compile() {
	BUILD_PARAMS="CONFIG_BATMAN_ADV_DEBUG=$(usex debug y n)"
	BUILD_PARAMS+=" CONFIG_BATMAN_ADV_BLA=$(usex bla y n)"
	BUILD_PARAMS+=" CONFIG_BATMAN_ADV_DAT=$(usex dat y n)"
	BUILD_PARAMS+=" CONFIG_BATMAN_ADV_NC=$(usex nc y n)"
	BUILD_PARAMS+=" CONFIG_BATMAN_ADV_NC=$(usex mcast y n)"
	export BUILD_PARAMS
	export KERNELPATH="${KERNEL_DIR}"
	linux-mod_src_compile
}

src_install() {
	echo ${MODULE_NAMES}
	linux-mod_src_install
	dodoc {README,CHANGELOG}.rst
}
