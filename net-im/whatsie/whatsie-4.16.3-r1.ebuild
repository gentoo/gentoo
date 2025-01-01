# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix qmake-utils xdg

DESCRIPTION="Qt Based WhatsApp Client"
HOMEPAGE="https://github.com/keshavbhatt/whatsie"
SRC_URI="https://github.com/keshavbhatt/whatsie/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

QT_MIN="6.0.0"

DEPEND="
	x11-libs/libX11
	x11-libs/libxcb:=
	>=dev-qt/qtbase-${QT_MIN}:6[gui,network,widgets]
	>=dev-qt/qtpositioning-${QT_MIN}:6
	>=dev-qt/qtwebengine-${QT_MIN}:6[widgets]
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.16.3-qt6.patch"
	"${FILESDIR}/${PN}-4.16.3-respect-user-flags.patch"
)

src_prepare() {
	edos2unix downloadmanagerwidget.h downloadwidget.cpp downloadwidget.h
	default
}

src_configure() {
	eqmake6
	# IDK if there is a better way to do this, qt6 puts this in a different dir
	sed -e 's/bin\/qwebengine_convert_dict/libexec\/qwebengine_convert_dict/g' \
		-i Makefile || die
}

src_install() {
	einstalldocs
	INSTALL_ROOT="${ED}" emake install
}
