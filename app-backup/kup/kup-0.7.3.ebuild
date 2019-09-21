# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Backup scheduler for KDE's Plasma desktop"
HOMEPAGE="https://www.linux-apps.com/p/1127689"
SRC_URI="https://github.com/spersson/${PN^}/archive/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	dev-libs/libgit2:=
"
RDEPEND="${DEPEND}
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtsvg)
	app-backup/bup
	net-misc/rsync
	!app-text/kup
"

S="${WORKDIR}/${PN^}-${P}"

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_LIBGIT2=ON
	)
	kde5_src_configure
}
