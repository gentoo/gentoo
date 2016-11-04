# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Framework for solving common problems such as caching, randomisation, and more"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm x86"
IUSE="fam nls"

RDEPEND="
	$(add_qt_dep qtcore 'icu')
	fam? ( virtual/fam )
	!<kde-frameworks/kservice-5.2.0:5
"
DEPEND="${RDEPEND}
	x11-misc/shared-mime-info
	nls? ( $(add_qt_dep linguist-tools) )
"

PATCHES=( "${FILESDIR}/${P}-CVE-2016-7966-r1.patch" )

src_configure() {
	local mycmakeargs=(
		-D_KDE4_DEFAULT_HOME_POSTFIX=4
		$(cmake-utils_use_find_package fam FAM)
	)

	kde5_src_configure
}
