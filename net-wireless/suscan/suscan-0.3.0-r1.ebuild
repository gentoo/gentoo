# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR='emake'
inherit cmake

DESCRIPTION="a realtime DSP processing library"
HOMEPAGE="https://github.com/BatchDrake/suscan"
SRC_URI="https://github.com/BatchDrake/suscan/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libxml2:=
	media-libs/alsa-lib
	media-libs/libsndfile
	net-wireless/sigutils
	net-wireless/soapysdr:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND=""
