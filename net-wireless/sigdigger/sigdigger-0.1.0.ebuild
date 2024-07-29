# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qmake-utils

DESCRIPTION="The free digital signal analyzer"
HOMEPAGE="https://github.com/BatchDrake/SigDigger"
SRC_URI="https://github.com/BatchDrake/SigDigger/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-libs/libsndfile
	net-wireless/sigutils
	net-wireless/soapysdr:=
	net-wireless/suscan
	net-wireless/suwidgets
	sci-libs/fftw:3.0=
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/SigDigger-${PV}"

src_configure() {
	eqmake5 SIGDIGGER_PREFIX=/usr SigDigger.pro
}

src_install() {
	INSTALL_ROOT="${ED}" emake install
}
