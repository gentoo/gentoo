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
IUSE="qt6 test"

RESTRICT="test"

COMMON_DEPEND="
	dev-libs/glib:2
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtwebengine:5
		dev-qt/qtwidgets:5
		>=net-libs/accounts-qt-1.16_p20220803[qt5]
		>=net-libs/signond-8.61-r100[qt5]
	)
	qt6? (
		dev-qt/qtbase:6[dbus,gui,network,ssl,widgets]
		dev-qt/qtdeclarative:6
		dev-qt/qtwebengine:6[qml]
		>=net-libs/accounts-qt-1.16_p20220803[qt6]
		>=net-libs/signond-8.61-r100[qt6]
	)
	net-libs/libproxy
	x11-libs/libnotify
"
RDEPEND="${COMMON_DEPEND}
	!qt6? ( dev-qt/qtwebchannel:5 )
	qt6? ( dev-qt/qtwebchannel:6 )
"
DEPEND="${COMMON_DEPEND}
	test? (
		!qt6? ( dev-qt/qttest:5 )
	)
"

PATCHES=(
	# thanks to openSUSE
	"${FILESDIR}/${PN}-0.15_p20171022-webengine-cachedir-path.patch"
	"${FILESDIR}/${PN}-0.15_p20171022-fix-username-field-reading.patch"
	# downstream
	"${FILESDIR}/${PN}-0.15_p20171022-drop-fno-rtti.patch"
	"${FILESDIR}/${PN}-0.15_p20171022-disable-tests.patch"
)

src_configure() {
	if use qt6; then
		eqmake6 PREFIX="${EPREFIX}"/usr
	else
		eqmake5 PREFIX="${EPREFIX}"/usr
	fi
}

src_compile() {
	emake -j1
}

src_install() {
	emake INSTALL_ROOT="${D}" -j1 install
}
