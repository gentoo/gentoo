# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/molsketch/molsketch-0.2.0-r1.ebuild,v 1.7 2014/09/17 11:58:04 jlec Exp $

EAPI=3

inherit cmake-utils multilib

MY_P=${P/m/M}-Source

DESCRIPTION="A drawing tool for 2D molecular structures"
HOMEPAGE="http://molsketch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	=sci-chemistry/openbabel-2.2*
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qttest:4
	|| (
		>=dev-qt/qthelp-4.7.0:4[compat]
		<dev-qt/qthelp-4.7.0:4 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-openbabel-231.patch
	)

src_prepare() {
	sed -e "/LIBRARY DESTINATION/ s/lib/$(get_libdir)/g" \
		-i libmolsketch/src/CMakeLists.txt || die #351246
	sed -e "s:doc/molsketch:doc/${PF}:g" \
		-i molsketch/src/{CMakeLists.txt,mainwindow.cpp} || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOPENBABEL2_INCLUDE_DIR="${EPREFIX}/usr/include/openbabel-2.0"
		-DCMAKE_DISABLE_FIND_PACKAGE_KDE4=ON
	)
	cmake-utils_src_configure
}
