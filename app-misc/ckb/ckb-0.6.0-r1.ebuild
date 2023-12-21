# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev xdg

DESCRIPTION="Corsair K65/K70/K95 Driver"
HOMEPAGE="https://github.com/ckb-next/ckb-next"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ckb-next/ckb-next.git"
else
	SRC_URI="https://github.com/ckb-next/ckb-next/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/${PN}-next-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="systemd"

RDEPEND="
	dev-libs/libdbusmenu-qt
	dev-libs/quazip:0=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	|| (
		media-libs/libpulse
		media-sound/apulse[sdk]
	)
	virtual/libudev:=
	x11-libs/libxcb:=
	x11-libs/xcb-util-wm"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

PATCHES=(
	"${FILESDIR}/${P}-fix-bashism.patch"
)

src_configure() {
	local mycmakeargs=(
		-DDISABLE_UPDATER=yes
		-DFORCE_INIT_SYSTEM=$(usex systemd systemd openrc)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc CHANGELOG.md
}

pkg_postinst() {
	udev_reload

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "The ckb daemon will have to be started before use:"
		elog
			if use systemd ; then
			elog "# systemctl start ckb-next-daemon"
		else
			elog "# rc-config start ckb-next-daemon"
		fi
	fi
}

pkg_postrm() {
	udev_reload
}
