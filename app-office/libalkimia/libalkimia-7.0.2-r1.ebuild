# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
KMNAME="alkimia"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${KMNAME}/${PV}/${KMNAME}-${PV}.tar.xz"
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
	$(add_qt_dep qtdbus)
	!gmp? ( sci-libs/mpir:=[cxx] )
	gmp? ( dev-libs/gmp:0=[cxx] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
		$(cmake_use_find_package !gmp MPIR)
	)
	kde5_src_configure
}
