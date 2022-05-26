# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="System tray utility including support for KDE system tray icons"
HOMEPAGE="https://kolbusa.github.io/stalonetray/"
SRC_URI="https://github.com/kolbusa/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="debug +graceful-exit"

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="app-text/docbook-xml-dtd
	dev-libs/libxslt"

DOCS=( AUTHORS BUGS COPYING NEWS README.md TODO stalonetrayrc.sample stalonetray.html )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable debug) \
		$(use_enable graceful-exit) \
		--enable-native-kde
}

src_compile() {
	emake
	emake dist
}
