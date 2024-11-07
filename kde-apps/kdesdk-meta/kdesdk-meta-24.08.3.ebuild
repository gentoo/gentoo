# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="https://apps.kde.org/categories/development/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="cvs git mercurial perl php python subversion webengine"

RDEPEND="
	>=dev-build/dolphin-plugins-makefileactions-${PV}:*
	>=dev-util/massif-visualizer-${PV}:*
	>=kde-apps/kapptemplate-${PV}:*
	>=kde-apps/kcachegrind-${PV}:*
	>=kde-apps/kde-dev-scripts-${PV}:*
	>=kde-apps/kde-dev-utils-${PV}:*
	>=kde-apps/kdesdk-thumbnailers-${PV}:*
	>=kde-apps/kompare-${PV}:*
	>=kde-apps/libkomparediff2-${PV}:*
	>=kde-apps/poxml-${PV}:*
	>=kde-apps/umbrello-${PV}:*
	cvs? ( >=kde-apps/cervisia-${PV}:* )
	git? ( >=kde-apps/dolphin-plugins-git-${PV}:* )
	mercurial? ( >=kde-apps/dolphin-plugins-mercurial-${PV}:* )
	perl? ( >=dev-util/kio-perldoc-${PV}:* )
	python? ( >=kde-apps/lokalize-${PV}:* )
	subversion? ( >=kde-apps/dolphin-plugins-subversion-${PV}:* )
	webengine? (
		>=dev-util/kdevelop-${PV}:*
		php? ( >=dev-util/kdevelop-php-${PV}:* )
		python? ( >=dev-util/kdevelop-python-${PV}:* )
	)
"
