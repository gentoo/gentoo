# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/oyranos/oyranos-0.9.4-r2.ebuild,v 1.3 2015/05/27 20:31:04 tamiko Exp $

EAPI=5

inherit eutils flag-o-matic cmake-utils cmake-multilib

DESCRIPTION="colour management system allowing to share various settings across applications and services"
HOMEPAGE="http://www.oyranos.org/"
SRC_URI="mirror://sourceforge/oyranos/Oyranos/Oyranos%200.4/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X cairo cups doc exif fltk qt4 raw test"

RDEPEND="=app-admin/elektra-0.7*:0[${MULTILIB_USEDEP}]
	>=app-admin/elektra-0.7.1-r5:0[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	>=dev-libs/yajl-2.0.4-r1[${MULTILIB_USEDEP}]
	media-libs/icc-profiles-basiccolor-printing2009
	media-libs/icc-profiles-basiccolor-printing2009
	>=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}]
	>=media-libs/libXcm-0.5.2-r1[${MULTILIB_USEDEP}]
	cairo? ( >=x11-libs/cairo-1.12.14-r4[${MULTILIB_USEDEP}] )
	cups? ( >=net-print/cups-1.7.1-r1[${MULTILIB_USEDEP}] )
	exif? ( >=media-gfx/exiv2-0.23-r2[${MULTILIB_USEDEP}] )
	fltk? ( x11-libs/fltk:1 )
	qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 )
	raw? ( >=media-libs/libraw-0.15.4[${MULTILIB_USEDEP}] )
	X? ( >=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
		>=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-doc/doxygen
	media-gfx/graphviz"

RESTRICT="test"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/oyranos-config
)
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/oyranos/oyranos_version.h
)

CMAKE_REMOVE_MODULES_LIST="${CMAKE_REMOVE_MODULES_LIST} FindFltk FindXcm FindCUPS"

src_prepare() {
	einfo remove bundled libs
	rm -rf elektra* yajl || die

	epatch "${FILESDIR}/${P}"-buildsystem-r1.patch

	#upstream(ed) fixes, be more verbose, better xrandr handling
	epatch "${FILESDIR}/${P}"-fix-array-access.patch \
		"${FILESDIR}/${P}"-fix-oyRankMap-helper-functions-crashes.patch \
		"${FILESDIR}/${P}"-fix-oyStringSegment-crash.patch \
		"${FILESDIR}/${P}"-be-more-verbose.patch \
		"${FILESDIR}/${P}"-use-more-internal-xrandr-info.patch \
		"${FILESDIR}/${P}"-set-xcalib-to-screen-if-ge-xrandr-12.patch \
		"${FILESDIR}/${P}"-fix-double-object-release.patch \
		"${FILESDIR}/${P}"-omit-profile-with-error.patch \
		"${FILESDIR}/${P}"-fix-typos-and-grammar.patch

	#upstream fix for QA notice, gentoo bug 464254
	epatch "${FILESDIR}/${P}"-fix-runpaths.patch

	#fix really ugly and prominently visible typo (solved in 0.9.5)
	sed -e 's/Promt/Prompt/' \
		-i src/liboyranos_config/oyranos_texts.c po/*.{po,pot} settings/*xml || die

	if use fltk ; then
		#src/examples does not include fltk flags
		append-cflags $(fltk-config --cflags)
		append-cxxflags $(fltk-config --cxxflags)
	fi

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLIB_SUFFIX=${libdir#lib}

		$(usex X -DWANT_X11=1 "")
		$(usex cairo -DWANT_CAIRO=1 "")
		$(usex cups -DWANT_CUPS=1 "")
		$(usex exif -DWANT_EXIV2=1 "")
		$(usex raw -DWANT_LIBRAW=1 "")

		# only used in programs
		$(multilib_native_usex fltk -DWANT_FLTK=1 "")
		$(multilib_native_usex qt4 -DWANT_QT4=1 "")
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	if use doc; then
		mv "${ED%/}"/usr/share/doc/{${PN},${PF}} || die
	else
		rm -rf "${ED%/}"/usr/share/doc/${PN} || die
	fi

	dodoc AUTHORS ChangeLog README
}
