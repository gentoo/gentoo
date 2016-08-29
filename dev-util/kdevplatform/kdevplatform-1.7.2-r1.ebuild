# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DECLARATIVE_REQUIRED="always"
KMNAME="kdevelop"
KDE_LINGUAS="bs ca ca@valencia da de el en_GB es et fi fr gl it kk nb nl pl pt
pt_BR ru sk sl sv th tr uk zh_CN zh_TW"
VIRTUALDBUS_TEST="true"
VIRTUALX_REQUIRED="test"
WEBKIT_REQUIRED="always"
inherit kde4-base

DESCRIPTION="KDE development support libraries and apps"
LICENSE="GPL-2 LGPL-2"
IUSE="+classbrowser cvs debug +konsole reviewboard subversion"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 x86"
fi

RESTRICT="test"

COMMON_DEPEND="
	dev-libs/grantlee:0
	reviewboard? ( dev-libs/qjson )
	subversion? (
		dev-libs/apr
		dev-libs/apr-util
		dev-vcs/subversion
	)
"
DEPEND="${COMMON_DEPEND}
	classbrowser? ( dev-libs/boost )
"
RDEPEND="${COMMON_DEPEND}
	cvs? ( dev-vcs/cvs )
	konsole? ( $(add_kdeapps_dep konsolepart) )
	!<dev-util/kdevelop-${KDEVELOP_VERSION}:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build classbrowser)
		$(cmake-utils_use_build cvs)
		$(cmake-utils_use_build konsole)
		$(cmake-utils_use_find_package reviewboard QJSON)
		$(cmake-utils_use_build subversion)
	)

	kde4-base_src_configure
}
