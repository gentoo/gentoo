# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=4368bb77d9d1abc2978af514225ba4a42c29a646
inherit qmake-utils

DESCRIPTION="Online accounts signon UI"
HOMEPAGE="https://gitlab.com/accounts-sso/signon-ui"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"
IUSE="test"

BDEPEND="test? ( dev-qt/qttest:5 )"
DEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
	net-libs/accounts-qt
	net-libs/libproxy
	net-libs/signond
	x11-libs/libnotify
"
RDEPEND="${DEPEND}
	dev-qt/qtwebchannel:5
"

RESTRICT="test"

PATCHES=(
	# thanks to openSUSE
	"${FILESDIR}/${P}-webengine-cachedir-path.patch"
	"${FILESDIR}/${P}-fix-username-field-reading.patch"
	# downstream
	"${FILESDIR}/${P}-drop-fno-rtti.patch"
	"${FILESDIR}/${P}-disable-tests.patch"
)

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	eqmake5
}

src_compile() {
	emake -j1
}

src_install() {
	emake INSTALL_ROOT="${D}" -j1 install
}
