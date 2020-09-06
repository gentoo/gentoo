# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Command line tool for the YubiKey PIV application"
SRC_URI="https://github.com/Yubico/yubico-piv-tool/archive/yubico-piv-tool-${PV}.tar.gz"
HOMEPAGE="https://developers.yubico.com/yubico-piv-tool/ https://github.com/Yubico/yubico-piv-tool"

LICENSE="BSD-2"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:0=[-bindist]
	sys-apps/pcsc-lite
"
DEPEND="${RDEPEND}
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	test? ( dev-libs/check )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.1-install-man-page.patch
	"${FILESDIR}"/${PN}-2.1.1-tests-optional.patch
)

S="${WORKDIR}/${PN}-${P}"

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
