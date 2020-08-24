# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="https://kde.org/applications/development"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="cvs git mercurial python subversion +webkit"

RDEPEND="
	>=kde-apps/kapptemplate-${PV}:${SLOT}
	>=kde-apps/kcachegrind-${PV}:${SLOT}
	>=kde-apps/kde-dev-scripts-${PV}:${SLOT}
	>=kde-apps/kde-dev-utils-${PV}:${SLOT}
	>=kde-apps/kdesdk-kioslaves-${PV}:${SLOT}
	>=kde-apps/kdesdk-thumbnailers-${PV}:${SLOT}
	>=kde-apps/kompare-${PV}:${SLOT}
	>=kde-apps/kross-interpreters-${PV}:${SLOT}
	>=kde-apps/libkomparediff2-${PV}:${SLOT}
	>=kde-apps/poxml-${PV}:${SLOT}
	cvs? ( >=kde-apps/cervisia-${PV}:${SLOT} )
	git? ( >=kde-apps/dolphin-plugins-git-${PV}:${SLOT} )
	mercurial? ( >=kde-apps/dolphin-plugins-mercurial-${PV}:${SLOT} )
	python? ( >=kde-apps/lokalize-${PV}:${SLOT} )
	subversion? ( >=kde-apps/dolphin-plugins-subversion-${PV}:${SLOT} )
	webkit? ( >=kde-apps/umbrello-${PV}:${SLOT} )
"
