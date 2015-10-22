# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="af ar az be bg bn br bs ca cs csb cy da de el en_GB eo es et eu fa fi fo fr fy ga gl ha he hi hr hsb
hu id is it ja ka kk km ko ku lb lo lt lv mi mk mn ms mt nb nds ne nl nn nso oc pa pl pt pt_BR ro ru
rw se sk sl sq sr sr@Latn ss sv ta te tg th tr tt uk uz uz@cyrillic ven vi wa xh zh_CN zh_HK zh_TW zu"
KDE_HANDBOOK="optional"
KDE_DOC_DIRS="doc-digikam doc-showfoto"
inherit kde4-base

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Digital photo management application for KDE"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2
	handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="addressbook debug doc gphoto2 mysql semantic-desktop +thumbnails video"

CDEPEND="
	kde-apps/kdebase-kioslaves:4
	kde-apps/libkdcraw:4=
	kde-apps/libkexiv2:4=
	>=kde-apps/libkface-15.08.2-r1:4
	kde-apps/libkgeomap:4=
	kde-apps/libkipi:4
	kde-apps/marble:4=[plasma]
	kde-apps/kcmshell:4
	dev-qt/qtgui:4
	|| ( dev-qt/qtsql:4[mysql] dev-qt/qtsql:4[sqlite] )
	media-libs/jasper
	media-libs/lcms:2
	>=media-libs/lensfun-0.2.6
	media-libs/liblqr
	>=media-libs/libpgf-6.12.27
	media-libs/libpng:0=
	>=media-libs/opencv-3.0.0[contrib]
	media-libs/phonon[qt4]
	>=media-libs/tiff-3.8.2:0
	virtual/jpeg:0
	x11-libs/libX11
	addressbook? ( $(add_kdebase_dep kdepimlibs) )
	gphoto2? ( media-libs/libgphoto2:= )
	mysql? ( virtual/mysql )
	semantic-desktop? ( $(add_kdebase_dep baloo '' 4.12.0) )
"
RDEPEND="${CDEPEND}
	$(add_kdeapps_dep kreadconfig)
	media-plugins/kipi-plugins:4
	video? ( || (
		$(add_kdeapps_dep ffmpegthumbs)
		$(add_kdeapps_dep mplayerthumbs)
	) )
"
DEPEND="${CDEPEND}
	dev-cpp/eigen:3
	dev-libs/boost
	sys-devel/gettext
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${MY_P}/core"

RESTRICT=test
# bug 366505

src_prepare() {
	# just to make absolutely sure
	rm -rf "${WORKDIR}/${MY_P}/extra" || die

	# prepare the handbook
	mkdir doc-digikam doc-showfoto || die
	echo "add_subdirectory( en )" > doc-digikam/CMakeLists.txt || die
	mv "${WORKDIR}/${MY_P}/doc/${PN}/digikam" doc-digikam/en || die
	echo "add_subdirectory( en )" > doc-showfoto/CMakeLists.txt || die
	mv "${WORKDIR}/${MY_P}/doc/${PN}/showfoto" doc-showfoto/en || die
	sed -i -e 's:../digikam/:../../doc-digikam/en/:g' doc-showfoto/en/index.docbook || die

	# prepare the translations
	mv "${WORKDIR}/${MY_P}/po" po || die
	find po -name "*.po" -and -not -name "digikam.po" -delete || die

	echo "find_package(Msgfmt REQUIRED)" >> CMakeLists.txt || die
	echo "find_package(Gettext REQUIRED)" >> CMakeLists.txt || die
	echo "add_subdirectory( po )" >> CMakeLists.txt || die

	kde4-base_src_prepare

	if use handbook; then
		echo "add_subdirectory( doc-digikam )" >> CMakeLists.txt || die
		echo "add_subdirectory( doc-showfoto )" >> CMakeLists.txt || die
	fi
}

src_configure() {
	# LQR = only allows to choose between bundled/external
	local mycmakeargs=(
		-DENABLE_LCMS2=ON
		-DENABLE_OPENCV3=ON
		-DWITH_LQR=ON
		-DWITH_LENSFUN=ON
		$(cmake-utils_use_enable addressbook KDEPIMLIBSSUPPORT)
		-DWITH_MarbleWidget=ON
		$(cmake-utils_use_enable gphoto2 GPHOTO2)
		$(cmake-utils_use_with gphoto2)
		$(cmake-utils_use_enable thumbnails THUMBS_DB)
		$(cmake-utils_use_enable mysql INTERNALMYSQL)
		$(cmake-utils_use_enable mysql MYSQLSUPPORT)
		$(cmake-utils_use_enable debug DEBUG_MESSAGES)
		$(cmake-utils_use_enable semantic-desktop BALOOSUPPORT)
	)

	kde4-base_src_configure
}

src_compile() {
	local mytargets="all"
	use doc && mytargets+=" doc"

	kde4-base_src_compile ${mytargets}
}

src_install() {
	kde4-base_src_install

	# install the api documentation
	use doc && dodoc -r ${CMAKE_BUILD_DIR}/api/html
}
