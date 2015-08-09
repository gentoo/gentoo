# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdevelop"
KDE_LINGUAS="bs ca ca@valencia da de el es et fi fr gl it kk nb nl pl pt pt_BR
ru sk sl sv th uk zh_CN zh_TW"
VIRTUALDBUS_TEST="true"
VIRTUALX_REQUIRED="test"
EGIT_REPONAME="${PN}"
inherit kde4-base

DESCRIPTION="KDE development support libraries and apps"
LICENSE="GPL-2 LGPL-2"
IUSE="cvs debug reviewboard subversion"
SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.xz"

if [[ $PV == *9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~x86"
fi

RESTRICT="test"

DEPEND="
	dev-libs/boost:=
	dev-libs/grantlee:0
	reviewboard? ( dev-libs/qjson )
	subversion? (
		dev-libs/apr
		dev-libs/apr-util
		dev-vcs/subversion
	)
"
RDEPEND="${DEPEND}
	!<dev-util/kdevelop-${KDEVELOP_VERSION}:4
	$(add_kdeapps_dep konsole)
	cvs? ( dev-vcs/cvs )
"

PATCHES=( "${FILESDIR}/${P}-appwizard.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build cvs)
		$(cmake-utils_use_find_package reviewboard QJSON)
		$(cmake-utils_use_build subversion)
	)

	kde4-base_src_configure
}
