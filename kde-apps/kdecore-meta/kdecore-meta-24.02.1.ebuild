# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdecore - merge this to pull in the most basic applications"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+handbook +share +thumbnail +webengine"

RDEPEND="
	>=kde-apps/dolphin-${PV}:*
	>=kde-apps/kdialog-${PV}:*
	>=kde-apps/keditbookmarks-${PV}:*
	>=kde-apps/kfind-${PV}:*
	>=kde-apps/konsole-${PV}:*
	>=kde-apps/kwrite-${PV}:*
	handbook? ( >=kde-apps/khelpcenter-${PV}:* )
	webengine? ( || (
		>=www-client/falkon-${PV}
		>=kde-apps/konqueror-${PV}:*
	) )
"
# Optional runtime deps: kde-apps/dolphin
RDEPEND="${RDEPEND}
	share? ( kde-frameworks/purpose:6 )
	thumbnail? (
		>=kde-apps/ffmpegthumbs-${PV}:*
		>=kde-apps/thumbnailers-${PV}:*
	)
"
