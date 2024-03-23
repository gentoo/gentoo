# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="https://apps.kde.org/categories/development/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="cvs git mercurial perl php python subversion webengine"

RDEPEND="
	>=kde-apps/kapptemplate-${PV}:5
	>=kde-apps/kcachegrind-${PV}:5
	>=kde-apps/kde-dev-scripts-${PV}:5
	>=kde-apps/kde-dev-utils-${PV}:5
	>=kde-apps/kdesdk-thumbnailers-${PV}:5
	>=kde-apps/kompare-${PV}:5
	>=kde-apps/libkomparediff2-${PV}:5
	>=kde-apps/poxml-${PV}:5
	>=kde-apps/umbrello-${PV}:5
	cvs? ( >=kde-apps/cervisia-${PV}:5 )
	git? ( >=kde-apps/dolphin-plugins-git-${PV}:5 )
	mercurial? ( >=kde-apps/dolphin-plugins-mercurial-${PV}:5 )
	perl? ( >=dev-util/kio-perldoc-${PV}:5 )
	python? ( >=kde-apps/lokalize-${PV}:5 )
	subversion? ( >=kde-apps/dolphin-plugins-subversion-${PV}:5 )
	webengine? (
		>=dev-util/kdevelop-${PV}:5
		php? ( >=dev-util/kdevelop-php-${PV}:5 )
		python? ( >=dev-util/kdevelop-python-${PV}:5 )
	)
"
