# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kdecore - merge this to pull in the most basic applications"
HOMEPAGE="https://www.kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+handbook +webengine webkit"

RDEPEND="
	>=kde-apps/dolphin-${PV}:${SLOT}
	>=kde-apps/kdialog-${PV}:${SLOT}
	>=kde-apps/keditbookmarks-${PV}:${SLOT}
	>=kde-apps/kfind-${PV}:${SLOT}
	>=kde-apps/konsole-${PV}:${SLOT}
	>=kde-apps/kwrite-${PV}:${SLOT}
	handbook? ( >=kde-apps/khelpcenter-${PV}:${SLOT} )
	webengine? ( www-client/falkon )
	webkit? (
		>=kde-apps/konqueror-${PV}:${SLOT}[webengine?]
		kde-misc/kwebkitpart:5
	)
"
