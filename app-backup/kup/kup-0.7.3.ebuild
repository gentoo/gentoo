# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Backup scheduler for KDE's Plasma desktop"
HOMEPAGE="https://www.linux-apps.com/p/1127689"
SRC_URI="https://github.com/spersson/${PN^}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/libgit2:=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kinit-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
"
RDEPEND="${DEPEND}
	app-backup/bup
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	net-misc/rsync
"

S="${WORKDIR}/${PN^}-${P}"

PATCHES=( "${FILESDIR}/${P}-libgit2.patch" )

src_prepare() {
	ecm_src_prepare
	rm -r libgit2-0.19.0 || die "Failed to remove bundled libgit2-0.19.0"
}
