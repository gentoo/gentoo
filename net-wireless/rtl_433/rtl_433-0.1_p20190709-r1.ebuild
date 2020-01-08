# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Decode OOK modulated signals"
HOMEPAGE="https://github.com/merbanan/rtl_433"
if [[ $PV == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/merbanan/rtl_433"
	KEYWORDS=""
else
	COMMIT="496f82b54b8957dbdd1bb60a080aeccfd31da73e"
	SRC_URI="https://github.com/merbanan/rtl_433/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+rtlsdr soapy"

DEPEND="rtlsdr? ( net-wireless/rtl-sdr:= )
	soapy? ( net-wireless/soapysdr:= )"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DENABLE_RTLSDR="$(usex rtlsdr)"
		-DENABLE_SOAPYSDR="$(usex soapy)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	mv "${ED}/usr/etc" "${ED}/" || die
}
