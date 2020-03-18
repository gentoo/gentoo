# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="https://kde.org/applications/utilities https://utils.kde.org"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE="7zip cups floppy gpg lrz rar"

RDEPEND="
	>=kde-apps/ark-${PV}:${SLOT}
	>=kde-apps/filelight-${PV}:${SLOT}
	>=kde-apps/kate-${PV}:${SLOT}
	>=kde-apps/kbackup-${PV}:${SLOT}
	>=kde-apps/kcalc-${PV}:${SLOT}
	>=kde-apps/kcharselect-${PV}:${SLOT}
	>=kde-apps/kdebugsettings-${PV}:${SLOT}
	>=kde-apps/kdf-${PV}:${SLOT}
	>=kde-apps/kimagemapeditor-${PV}:${SLOT}
	>=kde-apps/kteatime-${PV}:${SLOT}
	>=kde-apps/ktimer-${PV}:${SLOT}
	>=kde-apps/kwalletmanager-${PV}:${SLOT}
	>=kde-apps/sweeper-${PV}:${SLOT}
	>=kde-apps/yakuake-${PV}:${SLOT}
	cups? ( >=kde-apps/print-manager-${PV}:${SLOT} )
	floppy? ( >=kde-apps/kfloppy-${PV}:${SLOT} )
	gpg? ( >=kde-apps/kgpg-${PV}:${SLOT} )
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
