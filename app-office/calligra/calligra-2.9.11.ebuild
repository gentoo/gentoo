# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# note: files that need to be checked for dependencies etc:
# CMakeLists.txt, kexi/CMakeLists.txt kexi/migration/CMakeLists.txt
# krita/CMakeLists.txt

EAPI=5

CHECKREQS_DISK_BUILD="4G"
KDE_HANDBOOK="optional"
KDE_LINGUAS_LIVE_OVERRIDE="true"
OPENGL_REQUIRED="optional"
WEBKIT_REQUIRED="optional"
inherit check-reqs kde4-base versionator

DESCRIPTION="KDE Office Suite"
HOMEPAGE="http://www.calligra.org/"

case ${PV} in
	2.[456789].[789]?)
		# beta or rc releases
		SRC_URI="mirror://kde/unstable/${P}/${P}.tar.xz" ;;
	2.[456789].?|2.[456789].??)
		# stable releases
		SRC_URI="mirror://kde/stable/${P}/${P}.tar.xz" ;;
	2.[456789].9999)
		# stable branch live ebuild
		SRC_URI="" ;;
	9999)
		# master branch live ebuild
		SRC_URI="" ;;
esac

LICENSE="GPL-2"
SLOT="4"

if [[ ${KDE_BUILD_TYPE} == release ]] ; then
	KEYWORDS="amd64 ~arm x86"
fi

IUSE="attica color-management +crypt +eigen +exif fftw +fontconfig freetds
+glew +glib +gsf gsl import-filter +jpeg jpeg2k +kdcraw +kdepim +lcms
marble mysql +okular openexr +pdf postgres spacenav sybase test tiff +threads
+truetype vc xbase +xml"

# Don't use Active, it's broken on desktops.
CAL_FTS="author braindump flow gemini karbon kexi krita plan sheets stage words"
for cal_ft in ${CAL_FTS}; do
	IUSE+=" calligra_features_${cal_ft}"
done
unset cal_ft

REQUIRED_USE="
	calligra_features_author? ( calligra_features_words )
	calligra_features_gemini? ( opengl )
	calligra_features_krita? ( eigen exif lcms opengl )
	calligra_features_plan? ( kdepim )
	calligra_features_sheets? ( eigen )
	calligra_features_stage? ( webkit )
	vc? ( calligra_features_krita )
	test? ( calligra_features_karbon )
"

RDEPEND="
	dev-lang/perl
	dev-libs/boost
	dev-qt/qtcore:4[exceptions]
	media-libs/libpng:0
	sys-libs/zlib
	virtual/libiconv
	attica? ( dev-libs/libattica )
	color-management? ( media-libs/opencolorio )
	crypt? ( app-crypt/qca:2[qt4(+)] )
	eigen? ( dev-cpp/eigen:3 )
	exif? ( media-gfx/exiv2:= )
	fftw? ( sci-libs/fftw:3.0 )
	fontconfig? ( media-libs/fontconfig )
	freetds? ( dev-db/freetds )
	glib? ( dev-libs/glib:2 )
	gsf? ( gnome-extra/libgsf )
	gsl? ( sci-libs/gsl )
	import-filter? (
		app-text/libetonyek
		app-text/libodfgen
		app-text/libwpd:*
		app-text/libwpg:*
		app-text/libwps
		dev-libs/librevenge
		media-libs/libvisio
	)
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:0 )
	kdcraw? ( $(add_kdeapps_dep libkdcraw) )
	kdepim? ( $(add_kdeapps_dep kdepimlibs) )
	lcms? (
		media-libs/lcms:2
		x11-libs/libX11
	)
	marble? ( $(add_kdeapps_dep marble) )
	mysql? ( virtual/mysql )
	okular? ( >=kde-apps/okular-4.4:4=[aqua=] )
	opengl? (
		media-libs/glew
		virtual/glu
	)
	openexr? ( media-libs/openexr )
	pdf? (
		app-text/poppler:=
		media-gfx/pstoedit
	)
	postgres? (
		dev-db/postgresql:*
		dev-libs/libpqxx
	)
	spacenav? ( dev-libs/libspnav )
	sybase? ( dev-db/freetds )
	tiff? ( media-libs/tiff:0 )
	truetype? ( media-libs/freetype:2 )
	vc? ( <dev-libs/vc-1.0.0 )
	xbase? ( dev-db/xbase )
	calligra_features_kexi? (
		>=dev-db/sqlite-3.8.7:3[extensions(+)]
		dev-libs/icu:=
	)
	calligra_features_krita? (
		dev-qt/qtdeclarative:4
		net-misc/curl
		x11-libs/libX11
		x11-libs/libXi
	)
	calligra_features_words? ( dev-libs/libxslt )
"
DEPEND="${RDEPEND}
	x11-misc/shared-mime-info
"

[[ ${PV} == 9999 ]] && LANGVERSION="2.9" || LANGVERSION="$(get_version_component_range 1-2)"
PDEPEND=">=app-office/calligra-l10n-${LANGVERSION}"

# bug 394273
RESTRICT=test

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	kde4-base_pkg_setup
	check-reqs_pkg_setup
}

src_prepare() {
	if ! use webkit; then
		sed -i CMakeLists.txt -e "/^find_package/ s/QtWebKit //" || die
	fi
	kde4-base_src_prepare
}

src_configure() {
	local cal_ft myproducts

	# applications
	for cal_ft in ${CAL_FTS}; do
		# Switch to ^^ when we switch to EAPI=6.
		#local prod=${cal_ft^^}
		local prod=$(tr '[:lower:]' '[:upper:]' <<<"${cal_ft}")
		use calligra_features_${cal_ft} && myproducts+=( "${prod}" )
	done

	local mycmakeargs=( -DPRODUCTSET="${myproducts[*]}" )

	# first write out things we want to hard-enable
	mycmakeargs+=(
		"-DWITH_Iconv=ON"            # available on all supported arches and many more
	)

	# default disablers
	mycmakeargs+=(
		"-DCREATIVEONLY=OFF"
		"-DPACKAGERS_BUILD=OFF"
		"-DWITH_Soprano=OFF"
		"-DWITH_KActivities=OFF"	# deprecated Plasma 4 activities integration
	)

	# regular options
	mycmakeargs+=(
		$(cmake-utils_use_with attica LibAttica)
		$(cmake-utils_use_with color-management OCIO)
		$(cmake-utils_use_with crypt QCA2)
		$(cmake-utils_use_with eigen Eigen3)
		$(cmake-utils_use_with exif Exiv2)
		$(cmake-utils_use_with fftw FFTW3)
		$(cmake-utils_use_with fontconfig Fontconfig)
		$(cmake-utils_use_with freetds FreeTDS)
		$(cmake-utils_use_with glib GLIB2)
		$(cmake-utils_use_with gsl GSL)
		$(cmake-utils_use_with import-filter LibEtonyek)
		$(cmake-utils_use_with import-filter LibOdfGen)
		$(cmake-utils_use_with import-filter LibRevenge)
		$(cmake-utils_use_with import-filter LibVisio)
		$(cmake-utils_use_with import-filter LibWpd)
		$(cmake-utils_use_with import-filter LibWpg)
		$(cmake-utils_use_with import-filter LibWps)
		$(cmake-utils_use_with jpeg JPEG)
		$(cmake-utils_use_with jpeg2k OpenJPEG)
		$(cmake-utils_use_with kdcraw Kdcraw)
		$(cmake-utils_use_with kdepim KdepimLibs)
		$(cmake-utils_use_with lcms LCMS2)
		$(cmake-utils_use_with marble CalligraMarble)
		$(cmake-utils_use_with mysql MySQL)
		$(cmake-utils_use_with okular Okular)
		$(cmake-utils_use_with openexr OpenEXR)
		$(cmake-utils_use opengl USEOPENGL)
		$(cmake-utils_use_with pdf Poppler)
		$(cmake-utils_use_with pdf Pstoedit)
		$(cmake-utils_use_with postgres CalligraPostgreSQL)
		$(cmake-utils_use_build postgres pqxx)
		$(cmake-utils_use_with spacenav Spnav)
		$(cmake-utils_use_with sybase FreeTDS)
		$(cmake-utils_use_with tiff TIFF)
		$(cmake-utils_use_with threads Threads)
		$(cmake-utils_use_with truetype Freetype)
		$(cmake-utils_use_with vc Vc)
		$(cmake-utils_use_with xbase XBase)
	)

	mycmakeargs+=( $(cmake-utils_use_build test cstester) )

	kde4-base_src_configure
}
