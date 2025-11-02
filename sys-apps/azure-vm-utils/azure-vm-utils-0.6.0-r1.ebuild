# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="Utilities and udev rules to support Linux on Azure"
HOMEPAGE="https://github.com/Azure/azure-vm-utils"
SRC_URI="https://github.com/Azure/${PN}/archive/refs/tags/v${PV}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="dracut test"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-libs/json-c:=
"
DEPEND="
	${CDEPEND}
	test? ( dev-util/cmocka )
"
RDEPEND="
	${CDEPEND}
	dracut? ( sys-kernel/dracut )
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DDRACUT=$(usex dracut dracut "")
		-DENABLE_TESTS=$(usex test)
		-DINITRAMFS_TOOLS=
		-DUDEV_RULES_INSTALL_DIR="$(get_udevdir)/rules.d"
		-DVERSION="v${PV}"
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
