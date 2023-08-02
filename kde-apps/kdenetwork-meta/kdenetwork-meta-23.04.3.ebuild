# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="+bittorrent dropbox samba telepathy +webengine"

RDEPEND="
	>=kde-apps/kget-${PV}:${SLOT}
	>=kde-apps/kopete-${PV}:${SLOT}
	>=kde-apps/krdc-${PV}:${SLOT}
	>=kde-apps/krfb-${PV}:${SLOT}
	>=kde-misc/kdeconnect-${PV}:${SLOT}
	>=net-im/neochat-${PV}
	>=net-im/tokodon-${PV}
	>=net-irc/konversation-${PV}:${SLOT}
	>=net-misc/kio-zeroconf-${PV}:${SLOT}
	>=net-news/alligator-${PV}
	bittorrent? (
		>=net-libs/libktorrent-${PV}:${SLOT}
		>=net-p2p/ktorrent-${PV}:${SLOT}
	)
	dropbox? ( >=kde-apps/dolphin-plugins-dropbox-${PV}:${SLOT} )
	samba? ( >=kde-apps/kdenetwork-filesharing-${PV}:${SLOT} )
	telepathy? ( kde-apps/plasma-telepathy-meta:${SLOT} )
	webengine? ( >=kde-misc/kio-gdrive-${PV}:${SLOT} )
"
