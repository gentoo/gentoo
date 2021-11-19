# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Command-line tool and p11-kit module for the YubiKey PIV application"
HOMEPAGE="https://developers.yubico.com/yubico-piv-tool/ https://github.com/Yubico/yubico-piv-tool"
SRC_URI="https://github.com/Yubico/${PN}/archive/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/2"
KEYWORDS="~amd64 ~riscv"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="sys-apps/pcsc-lite
	dev-libs/openssl:=[-bindist(-)]"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"
BDEPEND="dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.1-no-Werror.patch
	"${FILESDIR}"/${PN}-2.1.1-tests-optional.patch
	"${FILESDIR}"/${PN}-2.1.1-ykcs11-threads.patch
	"${FILESDIR}"/${PN}-2.2.1-openssl3.patch
)

S="${WORKDIR}/${PN}-${P}"

src_configure() {
	# As of 2.2.0, man pages end up in /usr/usr/... without the MANDIR override
	local mycmakeargs=(
		-DBUILD_STATIC_LIB=OFF
		-DBUILD_TESTING=$(usex test)
		-DCMAKE_INSTALL_MANDIR="share/man"
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
