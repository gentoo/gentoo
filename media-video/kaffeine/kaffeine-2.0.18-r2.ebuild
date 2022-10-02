# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
KFMIN=5.92.0
QTMIN=5.15.5
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz
	https://linuxtv.org/downloads/dtv-scan-tables/${PN}/scantable.dvb -> ${P}-scantable.dvb"
<<<<<<< HEAD
	KEYWORDS="amd64 x86"
=======
	KEYWORDS="amd64 ~x86"
>>>>>>> 3928948a06b (rebase)
fi

DESCRIPTION="Media player with digital TV support by KDE"
HOMEPAGE="https://apps.kde.org/kaffeine/ https://userbase.kde.org/Kaffeine"

LICENSE="GPL-2+ handbook? ( FDL-1.3 )"
SLOT="5"
IUSE="dvb"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5[sqlite]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	media-video/vlc[X]
	x11-libs/libXScrnSaver
	dvb? ( media-libs/libv4l[dvb] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( Changelog NOTES README.md )

PATCHES=( "${FILESDIR}/${P}-wayland-window-activation.patch" )

src_prepare() {
	ecm_src_prepare
	cp -av "${DISTDIR}"/kaffeine-2.0.18-scantable.dvb src/scantable.dvb || die
}

src_configure() {
	# tools working on $HOME directory for a local git checkout
	local mycmakeargs=(
		-DBUILD_TOOLS=OFF
		$(cmake_use_find_package dvb Libdvbv5)
	)

	ecm_src_configure
}
