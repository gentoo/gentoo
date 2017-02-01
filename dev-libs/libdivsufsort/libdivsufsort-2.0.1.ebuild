# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils multilib

DESCRIPTION="Suffix-sorting library (for BWT)"
HOMEPAGE="https://github.com/y-256/libdivsufsort"
SRC_URI="https://github.com/y-256/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	cmake-utils_src_prepare

	# will appreciate saner approach, if there is any
	sed -i -e "s:\(DESTINATION \)lib:\1$(get_libdir):" \
		*/CMakeLists.txt || die
}
