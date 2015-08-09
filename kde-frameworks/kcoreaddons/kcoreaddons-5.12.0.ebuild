# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fdo-mime kde5

DESCRIPTION="Framework for solving common problems such as caching, randomisation, and more"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="fam nls"

RDEPEND="
	dev-qt/qtcore:5[icu]
	fam? ( virtual/fam )
	!<kde-frameworks/kservice-5.2.0:5
"
DEPEND="${RDEPEND}
	x11-misc/shared-mime-info
	nls? ( dev-qt/linguist-tools:5 )
"

src_configure() {
	local mycmakeargs=(
		-D_KDE4_DEFAULT_HOME_POSTFIX=4
		$(cmake-utils_use_find_package fam FAM)
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst
	fdo-mime_mime_database_update
}

pkg_postrm() {
	kde5_pkg_postinst
	fdo-mime_mime_database_update
}
