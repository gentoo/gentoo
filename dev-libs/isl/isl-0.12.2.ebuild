# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib-minimal

DESCRIPTION="A library for manipulating integer points bounded by linear constraints"
HOMEPAGE="http://isl.gforge.inria.fr/"
SRC_URI="http://isl.gforge.inria.fr/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/10"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

RDEPEND=">=dev-libs/gmp-5.1.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog AUTHORS doc/manual.pdf )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.07-gdb-autoload-dir.patch

	# m4/ax_create_pkgconfig_info.m4 is broken but avoid eautoreconf
	# https://groups.google.com/group/isl-development/t/37ad876557e50f2c
	sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die #382737
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
