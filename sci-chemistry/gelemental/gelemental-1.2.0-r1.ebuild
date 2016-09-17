# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils fdo-mime flag-o-matic gnome2-utils eutils

DESCRIPTION="Periodic table viewer with detailed information on the chemical elements"
HOMEPAGE="http://freecode.com/projects/gelemental/"
SRC_URI="
	http://www.kdau.com/files/${P}.tar.bz2
	mirror://debian/pool/main/g/${PN}/${PN}_${PV}-8.debian.tar.gz"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc static-libs"

RDEPEND="
	dev-cpp/gtkmm:2.4
	dev-cpp/glibmm:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	doc? ( app-doc/doxygen )"

PATCHES=(
		"${FILESDIR}"/${P}-gcc4.3.patch
		"${FILESDIR}"/${P}-glib-2.32.patch
		"${FILESDIR}"/${P}-doxygen.patch
		"${WORKDIR}"/debian/patches/579183_adjust_size_middle_button.patch
		"${WORKDIR}"/debian/patches/604612_fix_menu_category.patch
		"${WORKDIR}"/debian/patches/604618_scrollable_properties_dialog.patch
		"${WORKDIR}"/debian/patches/656372_element_renames.patch
		"${WORKDIR}"/debian/patches/add_new_wave_theme.patch
		"${WORKDIR}"/debian/patches/czech_translation_559028.patch
		"${WORKDIR}"/debian/patches/fix_gtkmm_2.18.patch
		"${WORKDIR}"/debian/patches/fix_zinc_german_translation.patch
		"${WORKDIR}"/debian/patches/ftbfs_missing_limits.patch
		"${WORKDIR}"/debian/patches/lp673285_link_in_about.patch
		"${FILESDIR}"/${PN}-1.2.0-fix-c++14.patch
	)

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	append-cxxflags -std=c++11 #566450
	local myeconfargs=( $(use_enable doc api-docs) )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install apidir="/usr/share/doc/${PF}/html"
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
