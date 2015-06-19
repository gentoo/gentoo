# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/plasma-wifi/plasma-wifi-0.5-r1.ebuild,v 1.2 2014/08/05 16:31:41 mrueg Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KDE4 plasmoid. Displays the currect signal strength"
HOMEPAGE="http://www.kde-look.org/content/show.php/cpuload?content=79476"
SRC_URI="http://kde-look.org/CONTENT/content-files/79476-${P}.tgz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"

src_prepare() {
	sed -i "s:find_package(Plasma REQUIRED)::" CMakeLists.txt || die "sed failed"
	sed -i "s:PLASMA_LIBS:KDE4_PLASMA_LIBS:" CMakeLists.txt || die "sed failed"

	kde4-base_src_prepare
}
