# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdecore - merge this to pull in the most basic applications"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~x86"
IUSE="+handbook +share +thumbnail +webengine"

RDEPEND="
	>=kde-apps/dolphin-${PV}:5
	>=kde-apps/kdialog-${PV}:5
	>=kde-apps/keditbookmarks-${PV}:5
	>=kde-apps/kfind-${PV}:5
	>=kde-apps/konsole-${PV}:5
	>=kde-apps/kwrite-${PV}:5
	handbook? ( >=kde-apps/khelpcenter-${PV}:5 )
	webengine? ( || (
		>=www-client/falkon-${PV}
		>=kde-apps/konqueror-${PV}:5
	) )
"
# Optional runtime deps: kde-apps/dolphin
RDEPEND="${RDEPEND}
	share? ( kde-frameworks/purpose:5 )
	thumbnail? (
		>=kde-apps/ffmpegthumbs-${PV}:5
		>=kde-apps/thumbnailers-${PV}:5
	)
"
