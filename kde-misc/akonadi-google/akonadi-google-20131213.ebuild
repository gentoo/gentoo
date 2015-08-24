# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_SCM="git"
inherit kde4-base

EGIT_REPO_URI="git://anongit.kde.org/akonadi-googledata-resource"
DESCRIPTION="Google services integration in Akonadi"
HOMEPAGE="https://projects.kde.org/projects/unmaintained/akonadi-googledata-resource"
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.xz"
LICENSE="GPL-2"

SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop(+)')
	dev-libs/libxslt
	dev-libs/qjson
	>=net-libs/libkgapi-2:4
	!>=kde-base/kdepim-runtime-4.8.50
"
RDEPEND=${DEPEND}

src_configure() {
	mycmakeargs=(
		-DKCAL=OFF
	)
	kde4-base_src_configure
}
