# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/phonon-qt7/phonon-qt7-0_pre20110424.ebuild,v 1.7 2012/10/01 17:45:14 grobian Exp $

EAPI=4

inherit cmake-utils base

DESCRIPTION="Phonon QuickTime7 backend"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/phonon/phonon-quicktime"
SRC_URI="http://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="~ppc-macos ~x64-macos"
SLOT="0"
IUSE="debug"

RDEPEND=">=media-libs/phonon-4.5"
DEPEND="${RDEPEND}
	>=dev-util/automoc-0.9.87
	media-libs/opengl-apple
	sys-devel/gcc-apple[objc]
	virtual/pkgconfig
"

# needs OpenGL, how do I specify this properly?
# I just depended on opengl-apple, hope this is what you meant -- grobian

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${PN}-noshow.patch"
	"${FILESDIR}"/${P}-QWidget-cast-dynamic.patch
	"${FILESDIR}"/${P}-darwin11.patch
)

src_prepare() {
	base_src_prepare  # for PATCHES
	sed -i -e "/^include_directories/s:): ${EPREFIX}/usr/include):" \
		CMakeLists.txt || die
}
