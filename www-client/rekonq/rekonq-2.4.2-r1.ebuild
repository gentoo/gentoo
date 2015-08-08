# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WEBKIT_REQUIRED="always"
KDE_LINGUAS="cs da de el es et eu fi fr gl hu ia it km lt mr nb nl pl pt pt_BR
sk sl sr sr@ijekavian sr@ijekavianlatin sr@latin sv tr uk zh_CN zh_TW"
KDE_HANDBOOK="optional"
KDE_MINIMAL="4.13.1"
inherit kde4-base

DESCRIPTION="A browser based on qtwebkit"
HOMEPAGE="http://rekonq.kde.org/"
[[ ${PV} != *9999* ]] && SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug kde nepomuk opera"

DEPEND="
	$(add_kdebase_dep kdelibs 'nepomuk?')
	kde? ( $(add_kdebase_dep kactivities) )
	nepomuk? (
		$(add_kdebase_dep nepomuk-core)
		dev-libs/soprano
	)
	opera? (
		app-crypt/qca:2[qt4(+)]
		dev-libs/qoauth
	)
"
RDEPEND="
	${DEPEND}
	$(add_kdeapps_dep kdebase-kioslaves)
	$(add_kdeapps_dep keditbookmarks)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with kde KActivities)
		$(cmake-utils_use_with opera QCA2)
		$(cmake-utils_use_with opera QtOAuth)
		$(cmake-utils_use_find_package nepomuk NepomukCore)
	)

	kde4-base_src_configure
}
