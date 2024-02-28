# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="+bittorrent dropbox samba +screencast +webengine"

RDEPEND="
	>=kde-apps/kget-${PV}:5
	>=kde-apps/krdc-${PV}:5
	>=kde-misc/kdeconnect-${PV}:5
	>=net-im/neochat-${PV}
	>=net-im/tokodon-${PV}
	>=net-irc/konversation-${PV}:5
	>=net-misc/kio-zeroconf-${PV}:5
	>=net-news/alligator-${PV}
	bittorrent? (
		>=net-libs/libktorrent-${PV}:5
		>=net-p2p/ktorrent-${PV}:5
	)
	dropbox? ( >=kde-apps/dolphin-plugins-dropbox-${PV}:5 )
	samba? ( >=kde-apps/kdenetwork-filesharing-${PV}:5 )
	screencast? ( >=kde-apps/krfb-${PV}:5 )
	webengine? ( >=kde-misc/kio-gdrive-${PV}:5 )
"
