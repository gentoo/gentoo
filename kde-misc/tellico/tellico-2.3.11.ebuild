# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bg bs ca ca@valencia cs da de el en_GB eo es et eu fi fr ga gl hu
ia it ja kk lt mr ms nb nds nl nn pl pt pt_BR ro ru sk sl sv tr ug uk zh_CN
zh_TW"
KDE_MINIMAL="4.13.1"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="A collection manager for the KDE environment"
HOMEPAGE="http://tellico-project.org/"
SRC_URI="http://tellico-project.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="addressbook cddb debug pdf scanner taglib v4l xmp yaz"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/qjson
	dev-qt/qtdbus:4
	media-libs/qimageblitz
	addressbook? ( $(add_kdeapps_dep kdepimlibs) )
	cddb? ( $(add_kdeapps_dep libkcddb) )
	pdf? ( app-text/poppler[qt4] )
	scanner? ( $(add_kdeapps_dep libksane) )
	taglib? ( >=media-libs/taglib-1.5 )
	v4l? ( >=media-libs/libv4l-0.8.3 )
	xmp? ( >=media-libs/exempi-2 )
	yaz? ( >=dev-libs/yaz-2:0 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

# tests need network access and well-defined server responses
RESTRICT="test"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local mycmakeargs=(
		-DWITH_Nepomuk=OFF
		$(cmake-utils_use_with addressbook KdepimLibs)
		$(cmake-utils_use_with cddb KdeMultimedia)
		$(cmake-utils_use_with pdf PopplerQt4)
		$(cmake-utils_use_with scanner KSane)
		$(cmake-utils_use_with taglib)
		$(cmake-utils_use_enable v4l WEBCAM)
		$(cmake-utils_use_with xmp Exempi)
		$(cmake-utils_use_with yaz)
	)

	kde4-base_src_configure
}
