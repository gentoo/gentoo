# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop cmake systemd

DESCRIPTION="Corsair K65/K70/K95 Driver"
HOMEPAGE="https://github.com/ckb-next/ckb-next"
SRC_URI="https://github.com/ckb-next/ckb-next/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/quazip-0.7.2[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	virtual/libudev:=
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
S="${WORKDIR}/${PN}-next-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-gcc10.patch"
)

src_configure() {
	local mycmakeargs=(
		-DDISABLE_UPDATER=yes
	)
	cmake_src_configure
}

src_install() {
	newinitd "${FILESDIR}"/ckb.initd ckb-daemon
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
