# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="https://kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="dropbox +webengine"

RDEPEND="
	>=kde-apps/kdenetwork-filesharing-${PV}:${SLOT}
	>=kde-apps/kget-${PV}:${SLOT}
	>=kde-apps/kopete-${PV}:${SLOT}
	>=kde-apps/krdc-${PV}:${SLOT}
	>=kde-apps/krfb-${PV}:${SLOT}
	>=kde-apps/zeroconf-ioslave-${PV}:${SLOT}
	>=kde-misc/kdeconnect-${PV}:${SLOT}
	dropbox? ( >=kde-apps/dolphin-plugins-dropbox-${PV}:${SLOT} )
	webengine? (
		>=kde-apps/plasma-telepathy-meta-${PV}:${SLOT}
		>=kde-misc/kio-gdrive-${PV}:${SLOT}
	)
"
