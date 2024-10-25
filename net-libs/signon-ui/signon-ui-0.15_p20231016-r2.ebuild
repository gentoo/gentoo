# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

if [[ ${PV} = *9999* ]] ; then
	EGIT_REPO_URI="https://gitlab.com/accounts-sso/signon-ui.git/"
	inherit git-r3
else
	COMMIT=eef943f0edf3beee8ecb85d4a9dae3656002fc24
	SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="amd64 arm64"
fi

DESCRIPTION="Online accounts signon UI"
HOMEPAGE="https://gitlab.com/accounts-sso/signon-ui"

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="test"

RESTRICT="test"

DEPEND="
	dev-libs/glib:2
	dev-qt/qtbase:6[dbus,gui,network,ssl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtwebengine:6[qml]
	>=net-libs/accounts-qt-1.17[qt6(+)]
	net-libs/libproxy
	>=net-libs/signond-8.61-r100[qt6(+)]
	x11-libs/libnotify
"
RDEPEND="${DEPEND}
	dev-qt/qtwebchannel:6
"

PATCHES=(
	# thanks to openSUSE
	"${FILESDIR}/${PN}-0.15_p20171022-webengine-cachedir-path.patch"
	# downstream
	"${FILESDIR}/${PN}-0.15_p20171022-drop-fno-rtti.patch"
	"${FILESDIR}/${PN}-0.15_p20171022-disable-tests.patch"
)

src_configure() {
	eqmake6 PREFIX="${EPREFIX}"/usr
}

src_compile() {
	emake -j1
}

src_install() {
	emake INSTALL_ROOT="${D}" -j1 install
}
