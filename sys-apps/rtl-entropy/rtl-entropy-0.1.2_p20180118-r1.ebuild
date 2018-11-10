# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="An entropy generator using SDR peripherals, including rtl-sdr and BladeRF"
HOMEPAGE="http://rtl-entropy.org/"
COMMIT="9f1768c35f6205a73a657cfc9ac7bd9f9a40936c"
SRC_URI="https://github.com/pwarren/rtl-entropy/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#sadly, rtlsdr support doesn't appear to be optional
IUSE="bladerf"

RDEPEND="sys-libs/libcap
		dev-libs/openssl:0=
		bladerf? ( net-wireless/bladerf:= )
		net-wireless/rtl-sdr"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_prepare() {
	if ! use bladerf; then
		sed -i 's#libbladeRF.h#libbladeRF-totallynotreal.h#' cmake/Modules/FindLibbladeRF.cmake
	fi
	#if ! use rtlsdr; then
	#	sed -i 's#rtl-sdr.h#rtl-sdr-totallynotreal.h#' cmake/Modules/FindLibRTLSDR.cmake
	#fi
	default
}
