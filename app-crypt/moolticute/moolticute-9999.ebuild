# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils systemd udev xdg-utils

if [[ ${PV} == *9999* ]]; then
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

RDEPEND="
	>=dev-libs/libusb-1.0.20
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	dev-qt/qtwebsockets:6
	virtual/libudev:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_prepare() {
	default

	# Fill version.h with package version
	if [[ ${PV} != *9999* ]]; then
		sed -i "s/\"git\"/\"v${PV/_/-}\"/" src/version.h || die
	fi
}

src_configure() {
	eqmake6 PREFIX="/usr" Moolticute.pro
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
