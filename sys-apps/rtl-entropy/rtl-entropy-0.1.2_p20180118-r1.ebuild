# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

COMMIT="9f1768c35f6205a73a657cfc9ac7bd9f9a40936c"

DESCRIPTION="An entropy generator using SDR peripherals, including rtl-sdr and BladeRF"
HOMEPAGE="http://rtl-entropy.org/"
SRC_URI="https://github.com/pwarren/rtl-entropy/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#sadly, rtlsdr support doesn't appear to be optional
IUSE="bladerf"

RDEPEND="
	dev-libs/openssl:0=
	net-wireless/rtl-sdr
	sys-libs/libcap
	bladerf? ( net-wireless/bladerf:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	cmake-utils_src_prepare

	if ! use bladerf; then
		sed -i 's#libbladeRF.h#libbladeRF-totallynotreal.h#' \
			cmake/Modules/FindLibbladeRF.cmake || die
	fi
}
