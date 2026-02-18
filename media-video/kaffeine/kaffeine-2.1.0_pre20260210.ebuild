# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
KDE_ORG_COMMIT=22c6a2c0508a880db796465734996a8a6d6fbaeb
KFMIN=6.16.0
QTMIN=6.7.2
inherit ecm kde.org xdg

DESCRIPTION="Media player with digital TV support by KDE"
HOMEPAGE="https://apps.kde.org/kaffeine/ https://userbase.kde.org/Kaffeine"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/kde/${KDE_ORG_NAME}-${PV}-${KDE_ORG_COMMIT:0:8}.tar.gz"

LICENSE="GPL-2+ handbook? ( FDL-1.3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dvb"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,sql,widgets,xml]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	=media-video/vlc-3*[X]
	dvb? ( media-libs/libv4l[dvb] )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( Changelog NOTES README.md )

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch" # Pending upstream
	"${FILESDIR}/${P}-fix-epgdata.dvb-read.patch" # KDE-bug 497475
)

src_configure() {
	# tools working on $HOME directory for a local git checkout
	local mycmakeargs=(
		-DBUILD_TOOLS=OFF
		$(cmake_use_find_package dvb Libdvbv5)
	)

	ecm_src_configure
}
