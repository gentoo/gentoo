# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils systemd udev xdg-utils

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/mooltipass/moolticute.git"
	inherit git-r3
else
	SRC_URI="https://github.com/mooltipass/moolticute/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

DESCRIPTION="Mooltipass crossplatform daemon/tools"
HOMEPAGE="https://github.com/mooltipass/moolticute"

LICENSE="GPL-3"
SLOT="0"
IUSE="systemd"

RDEPEND="
	>=dev-libs/libusb-1.0.20
	dev-qt/qtdbus:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	systemd? ( sys-apps/systemd )
	!systemd? ( sys-apps/systemd-utils )
"
BDEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

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

	udev_dorules "${FILESDIR}/50-mooltipass.rules"
	systemd_dounit systemd/moolticuted.service
	newinitd "${FILESDIR}/moolticuted.init" moolticuted
}

pkg_postinst() {
	udev_reload
	xdg_icon_cache_update
}

pkg_postrm() {
	udev_reload
	xdg_icon_cache_update
}
