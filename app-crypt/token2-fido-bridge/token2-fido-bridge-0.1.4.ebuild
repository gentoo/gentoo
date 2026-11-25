# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info optfeature systemd udev

DESCRIPTION="Expose PC/SC smartcards as virtual FIDO2/WebAuthn USB-HID security keys"
HOMEPAGE="https://github.com/token2/token2-fido-bridge"
SRC_URI="https://github.com/token2/token2-fido-bridge/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-apps/pcsc-lite"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~HIDRAW ~UHID"

PATCHES=(
	"${FILESDIR}"/${P}-systemd-sandboxing.patch
)

src_prepare() {
	cmake_src_prepare

	# Upstream hardcodes /usr/lib/{systemd,udev} install paths;
	# install these with the eclass helpers in src_install instead.
	sed -i -e '/^install(FILES packaging\//d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DSTATIC_CXX_RUNTIME=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	systemd_dounit packaging/${PN}.service
	udev_dorules packaging/70-${PN}.rules
	insinto /usr/lib/modules-load.d
	newins packaging/uhid.conf ${PN}-uhid.conf
}

pkg_postinst() {
	udev_reload
	optfeature "USB CCID smartcard readers" app-crypt/ccid
}

pkg_postrm() {
	udev_reload
}
