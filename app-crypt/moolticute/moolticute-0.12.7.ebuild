# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/mooltipass/moolticute.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/mooltipass/moolticute/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

inherit gnome2-utils qmake-utils udev

DESCRIPTION="Mooltipass crossplatform daemon/tools"
HOMEPAGE="https://github.com/mooltipass/moolticute"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-libs/libusb-1.0.20
	>=dev-qt/qtcore-5.6:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	default

	# Fill version.h with package version
	if [[ ${PV} != 9999* ]]; then
		sed -i "s/\"git\"/\"v${PV/_/-}\"/" src/version.h || die
	fi
}

src_configure() {
	eqmake5 PREFIX="/usr" Moolticute.pro
}

src_install() {
	emake install INSTALL_ROOT="${D}"

	udev_dorules "${FILESDIR}/50-mooltipass.rule"
	newinitd "${FILESDIR}/moolticuted.init" moolticuted
}

pkg_postinst() {
	udev_reload
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
