# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/qimageblitz/qimageblitz-0.0.6-r1.ebuild,v 1.8 2015/01/29 17:55:03 mgorny Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="A graphical effect and filter library for KDE4"
HOMEPAGE="http://websvn.kde.org/trunk/kdesupport/qimageblitz/"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
SLOT="0"
IUSE="cpu_flags_x86_3dnow altivec debug cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-9999-exec-stack.patch"
	"${FILESDIR}/${P}-gcc.patch"
)

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_has cpu_flags_x86_3dnow 3dnow)
		$(cmake-utils_use_has altivec)
		$(cmake-utils_use_has cpu_flags_x86_mmx mmx)
		$(cmake-utils_use_has cpu_flags_x86_sse sse)
		$(cmake-utils_use_has cpu_flags_x86_sse2 sse2)
	)
	cmake-utils_src_configure
}
