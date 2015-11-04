# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="Extensible binary format library (kinda like XML)"
HOMEPAGE="http://www.matroska.org/ https://github.com/Matroska-Org/libebml/"
SRC_URI="http://dl.matroska.org/downloads/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname major version
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug static-libs"

src_prepare() {
	sed -i '/^AM_CXXFLAGS += -g/d' Makefile.am || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
