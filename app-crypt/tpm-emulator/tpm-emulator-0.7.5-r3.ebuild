# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULES_OPTIONAL_USE="modules"
inherit cmake linux-mod udev

MY_P=${P/-/_}
DESCRIPTION="Emulator driver for tpm"
HOMEPAGE="https://github.com/PeterHuewe/tpm-emulator"
SRC_URI="https://github.com/PeterHuewe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mtm-emulator"

RDEPEND="
	acct-group/tpm
	acct-user/tpm
	dev-libs/gmp:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-static-libs.patch
)

pkg_setup() {
	if use modules; then
		CONFIG_CHECK="MODULES"
		MODULE_NAMES="tpmd_dev(extra:tpmd_dev/linux:)"
		BUILD_TARGETS="all tpmd_dev.rules"
		BUILD_PARAMS="KERNEL_BUILD=${KERNEL_DIR}"
		linux-mod_pkg_setup
	fi
}

src_configure() {
	local mycmakeargs=(
		-DMTM_EMULATOR=$(usex mtm-emulator ON OFF)
		-DBUILD_DEV=OFF
	)
	cmake_src_configure

	if use modules; then
		ln -s "${BUILD_DIR}/config.h" tpmd_dev/linux || die
	fi
}

src_compile() {
	cmake_src_compile
	use modules && linux-mod_src_compile
}

src_install() {
	cmake_src_install
	if use modules; then
		linux-mod_src_install
		udev_newrules "tpmd_dev/linux/tpmd_dev.rules" 60-tpmd_dev.rules
	fi

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir /var/log/tpm
	fowners tss:tss /var/log/tpm
}

pkg_postinst() {
	if use modules; then
		linux-mod_pkg_postinst

		ewarn ""
		ewarn "The new init.d script does not load the tpmd_dev any more as it is optional."
		ewarn "If you use the tpmd_dev, please load it explicitly in /etc/conf.d/modules"
		ewarn ""
	fi

	einfo "tpmd socket is located at /var/run/tpm/tpmd_socket:0"
}
