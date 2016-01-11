# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Remote delta-compression library"
HOMEPAGE="http://librsync.sourcefrog.net/"
SRC_URI="https://github.com/librsync/librsync/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}"

src_prepare() {
	# isprefix_test does not work in portage environment
	sed -i '169 s/^/#/' CMakeLists.txt || die

	# fix compiling with multilib-strict feature enabled
	sed -i "242 s/lib/$(get_libdir)/" CMakeLists.txt || die

	cmake-utils_src_prepare
}
