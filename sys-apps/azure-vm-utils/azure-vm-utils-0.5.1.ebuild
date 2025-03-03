# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="Utilities and udev rules to support Linux on Azure"
HOMEPAGE="https://github.com/Azure/azure-vm-utils"
SRC_URI="https://github.com/Azure/${PN}/archive/refs/tags/v${PV}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-util/cmocka )
"

src_configure() {
	local mycmakeargs=(
		-DUDEV_RULES_INSTALL_DIR="$(get_udevdir)/rules.d"
		-DENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Remove post-install test that only works on Azure.
	rm -v \
		"${ED}"/usr/sbin/azure-vm-utils-selftest \
		"${ED}"/usr/share/man/man*/azure-vm-utils-selftest.* \
		|| die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
