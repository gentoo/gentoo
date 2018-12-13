# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="https://www.kde.org/applications/utilities https://utils.kde.org"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="cups floppy"

RDEPEND="
	>=kde-apps/ark-${PV}:${SLOT}
	>=kde-apps/filelight-${PV}:${SLOT}
	>=kde-apps/kate-${PV}:${SLOT}
	>=kde-apps/kbackup-${PV}:${SLOT}
	>=kde-apps/kcalc-${PV}:${SLOT}
	>=kde-apps/kcharselect-${PV}:${SLOT}
	>=kde-apps/kdebugsettings-${PV}:${SLOT}
	>=kde-apps/kdf-${PV}:${SLOT}
	>=kde-apps/kgpg-${PV}:${SLOT}
	>=kde-apps/kimagemapeditor-${PV}:${SLOT}
	>=kde-apps/kteatime-${PV}:${SLOT}
	>=kde-apps/ktimer-${PV}:${SLOT}
	>=kde-apps/kwalletmanager-${PV}:${SLOT}
	>=kde-apps/sweeper-${PV}:${SLOT}
	cups? ( >=kde-apps/print-manager-${PV}:${SLOT} )
	floppy? ( >=kde-apps/kfloppy-${PV}:${SLOT} )
"
