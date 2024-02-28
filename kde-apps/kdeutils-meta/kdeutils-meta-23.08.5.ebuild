# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="https://apps.kde.org/categories/utilities/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~x86"
IUSE="7zip cups gpg lrz plasma rar +webengine"

RDEPEND="
	>=app-cdr/dolphin-plugins-mountiso-${PV}:5
	>=app-crypt/keysmith-${PV}
	>=kde-apps/ark-${PV}:5
	>=kde-apps/filelight-${PV}:5
	>=kde-apps/kate-${PV}:5
	>=kde-apps/kbackup-${PV}:5
	>=kde-apps/kcalc-${PV}:5
	>=kde-apps/kcharselect-${PV}:5
	>=kde-apps/kdebugsettings-${PV}:5
	>=kde-apps/kdf-${PV}:5
	>=kde-apps/kteatime-${PV}:5
	>=kde-apps/ktimer-${PV}:5
	>=kde-apps/kwalletmanager-${PV}:5
	>=kde-apps/sweeper-${PV}:5
	>=kde-apps/yakuake-${PV}:5
	>=kde-misc/kweather-${PV}:5
	>=kde-misc/markdownpart-${PV}:5
	>=sys-block/partitionmanager-${PV}:5
	>=sys-libs/kpmcore-${PV}:5
	cups? ( || (
		kde-plasma/print-manager:6
		>=kde-plasma/print-manager-${PV}:5
	) )
	gpg? ( >=kde-apps/kgpg-${PV}:5 )
	plasma? ( >=kde-misc/kclock-${PV} )
	webengine? (
		>=app-editors/ghostwriter-${PV}
		>=kde-apps/kimagemapeditor-${PV}:5
	)
"
# Optional runtime deps: kde-apps/ark
RDEPEND="${RDEPEND}
	7zip? ( app-arch/p7zip )
	lrz? ( app-arch/lrzip )
	rar? ( || (
		app-arch/rar
		app-arch/unrar
		app-arch/unar
	) )
"
