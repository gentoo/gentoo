# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib

DESCRIPTION="A wrapper to fake privilege separation"
HOMEPAGE="https://cwrap.org/uid_wrapper.html"
SRC_URI="ftp://ftp.samba.org/pub/cwrap/${P}.tar.gz
	https://ftp.samba.org/pub/cwrap/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"

# Work around a problem with >=dev-util/cmake-3.3.0 (bug #558340)
# Because of this we cannot use cmake-multilib_src_configure() here.
multilib_src_configure() {
	local mycmakeargs=( -DCMAKE_LIBRARY_PATH=/usr/$(get_libdir) )
	cmake-utils_src_configure
}
