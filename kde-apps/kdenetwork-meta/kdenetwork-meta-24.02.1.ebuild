# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bittorrent dropbox samba +screencast +webengine"

RDEPEND="
	>=kde-apps/kget-${PV}:*
	>=kde-apps/krdc-${PV}:*
	>=kde-misc/kdeconnect-${PV}:*
	>=net-im/neochat-${PV}
	>=net-im/tokodon-${PV}
	>=net-irc/konversation-${PV}:*
	>=net-misc/kio-zeroconf-${PV}:*
	>=net-news/alligator-${PV}
	bittorrent? (
		>=net-libs/libktorrent-${PV}:*
		>=net-p2p/ktorrent-${PV}:*
	)
	dropbox? ( >=kde-apps/dolphin-plugins-dropbox-${PV}:* )
	samba? ( >=kde-apps/kdenetwork-filesharing-${PV}:* )
	screencast? ( >=kde-apps/krfb-${PV}:* )
	webengine? ( >=kde-misc/kio-gdrive-${PV}:* )
"
