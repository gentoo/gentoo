# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libproccpuinfo/libproccpuinfo-0.0.8.ebuild,v 1.5 2012/06/02 09:47:36 scarabeus Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="Architecture independent C API for reading /proc/cpuinfo"
HOMEPAGE="https://savannah.nongnu.org/projects/proccpuinfo/"
SRC_URI="http://download.savannah.nongnu.org/releases/proccpuinfo/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~mips x86"
IUSE=""

DEPEND=">=sys-devel/flex-2.5.33"
RDEPEND=""

DOCS="AUTHORS ChangeLog HACKING README THANKS TODO"

CMAKE_IN_SOURCE_BUILD="yes"

src_prepare() {
	sed -i \
		-e "s#DESTINATION lib#DESTINATION $(get_libdir)#" \
		CMakeLists.txt || die
}
