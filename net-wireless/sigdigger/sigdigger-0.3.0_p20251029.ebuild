# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit qmake-utils xdg-utils

DESCRIPTION="The free digital signal analyzer"
HOMEPAGE="https://github.com/BatchDrake/SigDigger"
SRC_URI="https://dev.gentoo.org/~tomjbe/distfiles/SigDigger-${PV}.tgz"

S="${WORKDIR}/SigDigger-${PV}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	media-libs/alsa-lib
	media-libs/libsndfile
	net-misc/curl
	>=net-wireless/sigutils-0.3.0_p20251029
	net-wireless/soapysdr:=
	>=net-wireless/suscan-0.3.0_p20251029
	>=net-wireless/suwidgets-0.3.0_p20251029
	sci-libs/fftw:3.0=
"
RDEPEND="${DEPEND}"

src_configure() {
	#prevent stripping
	sed -i '/QMAKE_LFLAGS+=-s/d' SigDigger.pro
	eqmake6 PREFIX=/usr SigDigger.pro
}

src_install() {
	INSTALL_ROOT="${ED}" emake install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xxdg_icon_cache_update
}
