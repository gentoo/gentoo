# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Decode OOK modulated signals"
HOMEPAGE="https://github.com/merbanan/rtl_433"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/merbanan/rtl_433"
else
	SRC_URI="https://github.com/merbanan/rtl_433/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+rtlsdr soapysdr test"

DEPEND="rtlsdr? ( net-wireless/rtl-sdr:=
			virtual/libusb:1 )
	soapysdr? ( net-wireless/soapysdr:= )
	dev-libs/openssl:="
RDEPEND="${DEPEND}"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${P}-CVE.patch"
	"${FILESDIR}/${P}-test-visibility.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_RTLSDR="$(usex rtlsdr)"
		-DENABLE_SOAPYSDR="$(usex soapysdr)"
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${ED}/usr/etc" "${ED}/" || die
}
