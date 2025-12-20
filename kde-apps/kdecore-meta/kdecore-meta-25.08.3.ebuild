# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdecore - merge this to pull in the most basic applications"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~x86"
IUSE="+share +webengine"

RDEPEND="
	>=kde-apps/dolphin-${PV}:*
	>=kde-apps/kdialog-${PV}:*
	>=kde-apps/keditbookmarks-${PV}:*
	>=kde-apps/kfind-${PV}:*
	>=kde-apps/konsole-${PV}:*
	>=kde-apps/kwrite-${PV}:*
	webengine? (
		>=kde-apps/khelpcenter-${PV}:*
		|| (
			>=www-client/falkon-${PV}
			>=kde-apps/konqueror-${PV}:*
		)
	)
"
# Optional runtime deps: kde-apps/dolphin
RDEPEND="${RDEPEND}
	share? ( kde-frameworks/purpose:6 )
"
