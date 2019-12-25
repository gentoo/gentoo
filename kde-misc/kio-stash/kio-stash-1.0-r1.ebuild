# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KIO Slave and daemon to stash discontinuous file selections"
HOMEPAGE="https://arnavdhamija.com/2017/07/04/kio-stash-shipped/ https://cgit.kde.org/kio-stash.git"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT+=" test"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-no-kf5config.patch
	"${FILESDIR}"/${P}-kioslave-no-desktop-app.patch
)
