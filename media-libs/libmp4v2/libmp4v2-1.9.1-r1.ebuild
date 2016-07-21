# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# this ebuild is only for the libmp4v2.so.1 SONAME for ABI compat

EAPI=4
inherit libtool multilib

DESCRIPTION="Functions for accessing ISO-IEC:14496-1:2001 MPEG-4 standard"
HOMEPAGE="https://code.google.com/p/mp4v2/"
SRC_URI="https://mp4v2.googlecode.com/files/${P/lib}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="1"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RESTRICT="test"

RDEPEND="!<=${CATEGORY}/${PN}-1.9.1:0"
DEPEND="${RDEPEND}
	sys-apps/sed"

S=${WORKDIR}/${P/lib}

src_prepare() {
	elibtoolize
}

src_configure() {
	econf --disable-gch --disable-util --disable-static
}

src_compile() {
	emake ${PN}.la
}

src_install() {
	newlib.so .libs/${PN}$(get_libname ${PV}) ${PN}$(get_libname ${PV%.*.*})
}
