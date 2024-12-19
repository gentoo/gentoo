# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake verify-sig

DESCRIPTION="Command-line tool and p11-kit module for the YubiKey PIV application"
HOMEPAGE="https://developers.yubico.com/yubico-piv-tool/ https://github.com/Yubico/yubico-piv-tool"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz
	verify-sig? ( https://developers.yubico.com/${PN}/Releases/${P}.tar.gz.sig )"

LICENSE="BSD-2"
SLOT="0/2"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test verify-sig"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/yubico.com.asc"

RESTRICT="!test? ( test )"

RDEPEND="sys-apps/pcsc-lite
	dev-libs/openssl:=[-bindist(-)]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"
BDEPEND="dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	test? ( dev-libs/check )
	verify-sig? ( >=sec-keys/openpgp-keys-yubico-20240628 )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.1-tests-optional.patch
	"${FILESDIR}"/${PN}-2.1.1-ykcs11-threads.patch
	"${FILESDIR}"/${PN}-2.3.0-no-Werror.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIB=OFF
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	echo "module: ${EPREFIX}/usr/$(get_libdir)/libykcs11.so" > ${PN}.module \
		|| die "Failed to generate p11-kit module configuration"
	insinto /usr/share/p11-kit/modules
	doins ${PN}.module
}
