# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="af ar az be bg bn br bs ca cs csb cy da de el en_GB eo es et eu fa fi fo fr fy ga gl ha he hi hr hsb
hu id is it ja ka kk km ko ku lb lo lt lv mi mk mn ms mt nb nds ne nl nn nso oc pa pl pt pt_BR ro ru
rw se sk sl sq sr sr@Latn ss sv ta te tg th tr tt uk uz uz@cyrillic ven vi wa xh zh_CN zh_HK zh_TW zu"

KDE_HANDBOOK="optional"
CMAKE_MIN_VERSION="2.8"
KDE_MINIMAL="4.10"

KDE_DOC_DIRS="doc-digikam doc-showfoto"

inherit kde4-base

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Digital photo management application for KDE"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2
	handbook? ( FDL-1.2 )"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="addressbook debug doc gphoto2 mysql semantic-desktop themedesigner +thumbnails video"

CDEPEND="
	kde-apps/kdebase-kioslaves:4
	kde-apps/libkdcraw:4=
	kde-apps/libkexiv2:4=
	kde-apps/libkipi:4
	kde-apps/marble:4=[plasma]
	media-libs/jasper
	media-libs/lcms:2
	media-libs/lensfun
	|| ( kde-apps/libkface:4 <=media-libs/libkface-4.4.0 )
	media-libs/libkgeomap
	media-libs/liblqr
	>=media-libs/libpgf-6.12.27
	media-libs/libpng:0=
	>=media-libs/opencv-2.4.9
	media-libs/tiff
	virtual/jpeg
	dev-qt/qtgui:4
	|| ( dev-qt/qtsql:4[mysql] dev-qt/qtsql:4[sqlite] )
	addressbook? ( $(add_kdebase_dep kdepimlibs) )
	gphoto2? ( media-libs/libgphoto2:= )
	mysql? ( virtual/mysql )
	semantic-desktop? (
		$(add_kdebase_dep baloo)
	)
"
RDEPEND="${CDEPEND}
	kde-apps/kreadconfig:4
	media-plugins/kipi-plugins
	video? (
		|| (
			kde-apps/ffmpegthumbs:4
			kde-apps/mplayerthumbs:4
			$(add_kdeapps_dep mplayerthumbs)
			$(add_kdeapps_dep ffmpegthumbs)
		)
	)
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

PATCHES=(
	"${FILESDIR}/${P}-libkexiv2.patch"
	"${FILESDIR}/${P}-hang.patch"
)

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
	find po -name "*.po" -and -not -name "digikam.po" -exec rm {} +

	echo "find_package(Msgfmt REQUIRED)" >> CMakeLists.txt || die
	echo "find_package(Gettext REQUIRED)" >> CMakeLists.txt || die
	echo "add_subdirectory( po )" >> CMakeLists.txt || die

	kde4-base_src_prepare

	if use handbook; then
		echo "add_subdirectory( doc-digikam )" >> CMakeLists.txt
		echo "add_subdirectory( doc-showfoto )" >> CMakeLists.txt
	fi
}

src_configure() {
	# LQR = only allows to choose between bundled/external
	local mycmakeargs=(
		-DENABLE_LCMS2=ON
		-DFORCED_UNBUNDLE=ON
		-DWITH_LQR=ON
		-DWITH_LENSFUN=ON
		-DWITH_MarbleWidget=ON
		-DENABLE_NEPOMUKSUPPORT=OFF
		$(cmake-utils_use_enable addressbook KDEPIMLIBSSUPPORT)
		$(cmake-utils_use_enable gphoto2 GPHOTO2)
		$(cmake-utils_use_with gphoto2)
		$(cmake-utils_use_enable themedesigner)
		$(cmake-utils_use_enable thumbnails THUMBS_DB)
		$(cmake-utils_use_enable mysql INTERNALMYSQL)
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

	if use doc; then
		# install the api documentation
		insinto /usr/share/doc/${PF}/
		doins -r ${CMAKE_BUILD_DIR}/api/html
	fi
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if use doc; then
		einfo "The digikam api documentation has been installed at /usr/share/doc/${PF}/html"
	fi
}
