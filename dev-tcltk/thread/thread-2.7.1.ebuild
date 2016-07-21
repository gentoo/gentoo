# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib

MY_P="${PN}${PV}"
TCL_VER="8.6.2"

DESCRIPTION="Tcl Thread extension"
HOMEPAGE="http://www.tcl.tk/"
SRC_URI="mirror://sourceforge/project/tcl/Tcl/${TCL_VER}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="debug gdbm"

DEPEND="
	dev-lang/tcl:0=[threads]
	gdbm? ( sys-libs/gdbm )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}${PV}

RESTRICT="test"

src_prepare() {
	# Search for libs in libdir not just exec_prefix/lib
	sed -i -e 's:${exec_prefix}/lib:${libdir}:' \
		aclocal.m4 || die "sed failed"

	sed -i -e "s/relid'/relid/" tclconfig/tcl.m4 || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-tclinclude="${EPREFIX}/usr/include"
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
	)
	use gdbm && myconf+=( --with-gdbm )
	use debug && myconf+=( --enable-symbols )
	autotools-utils_src_configure
}
