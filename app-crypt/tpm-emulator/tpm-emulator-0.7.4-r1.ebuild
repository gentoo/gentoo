# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit user linux-mod cmake-utils udev

MY_P=${P/-/_}
DESCRIPTION="Emulator driver for tpm"
HOMEPAGE="https://sourceforge.net/projects/tpm-emulator.berlios/"
SRC_URI="mirror://sourceforge/tpm-emulator/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="libressl ssl modules"
RDEPEND="ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	!ssl? ( dev-libs/gmp )"

S=${WORKDIR}/${P/-/_}

pkg_setup() {
	enewuser tss -1 -1 /var/lib/tpm tss
	if use modules; then
		CONFIG_CHECK="MODULES"
		linux-mod_pkg_setup
		BUILD_TARGETS="all"
		BUILD_PARAMS="KERNEL_BUILD=${KERNEL_DIR}"
	fi
}

src_prepare() {
	# do not build and install the kernel module
	sed -i 's/COMMAND ${tpmd_dev_BUILD_CMD}//' tpmd_dev/CMakeLists.txt || die
	sed -i 's/install(CODE.*//' tpmd_dev/CMakeLists.txt || die
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_use ssl OPENSSL)
	)
	cmake-utils_src_configure

	# only here we have BUILD_DIR
	MODULE_NAMES="tpmd_dev(misc:${BUILD_DIR}/tpmd_dev/linux)"
}

src_compile() {
	cmake-utils_src_compile
	use modules && linux-mod_src_compile
	emake -C "${BUILD_DIR}/tpmd_dev/linux" tpmd_dev.rules
}

src_install() {
	cmake-utils_src_install
	use modules && linux-mod_src_install

	dodoc README

	udev_newrules "${BUILD_DIR}/tpmd_dev/linux/tpmd_dev.rules" 60-tpmd_dev.rules

	newinitd "${FILESDIR}"/${PN}.initd-0.7.4 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-0.7.4 ${PN}

	keepdir /var/log/tpm
	fowners tss:tss /var/log/tpm
}
