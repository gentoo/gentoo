# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="https://apps.kde.org/categories/development/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE="cvs git mercurial perl php python subversion webengine"

RDEPEND="
	>=kde-apps/kapptemplate-${PV}:${SLOT}
	>=kde-apps/kcachegrind-${PV}:${SLOT}
	>=kde-apps/kde-dev-scripts-${PV}:${SLOT}
	>=kde-apps/kde-dev-utils-${PV}:${SLOT}
	>=kde-apps/kdesdk-thumbnailers-${PV}:${SLOT}
	>=kde-apps/kompare-${PV}:${SLOT}
	>=kde-apps/libkomparediff2-${PV}:${SLOT}
	>=kde-apps/poxml-${PV}:${SLOT}
	>=kde-apps/umbrello-${PV}:${SLOT}
	cvs? ( >=kde-apps/cervisia-${PV}:${SLOT} )
	git? ( >=kde-apps/dolphin-plugins-git-${PV}:${SLOT} )
	mercurial? ( >=kde-apps/dolphin-plugins-mercurial-${PV}:${SLOT} )
	perl? ( >=dev-util/kio-perldoc-${PV}:${SLOT} )
	python? ( >=kde-apps/lokalize-${PV}:${SLOT} )
	subversion? ( >=kde-apps/dolphin-plugins-subversion-${PV}:${SLOT} )
	webengine? (
		>=dev-util/kdevelop-${PV}:${SLOT}
		php? ( >=dev-util/kdevelop-php-${PV}:${SLOT} )
		python? ( >=dev-util/kdevelop-python-${PV}:${SLOT} )
	)
"
