# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KDE_ORG_NAME="alkimia"
QTMIN=5.12.3
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${KDE_ORG_NAME}/${PV}/${KDE_ORG_NAME}-${PV}.tar.xz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Library with common classes and functionality used by KDE finance applications"
HOMEPAGE="https://www.linux-apps.com/content/show.php/libalkimia?content=137323"

LICENSE="LGPL-2.1"
SLOT="0/7"
IUSE="doc gmp"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	!gmp? ( sci-libs/mpir:=[cxx] )
	gmp? ( dev-libs/gmp:0=[cxx] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
		$(cmake_use_find_package !gmp MPIR)
	)
	ecm_src_configure
}
