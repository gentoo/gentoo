# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TODDR
MODULE_VERSION=2.44
inherit perl-module multilib

DESCRIPTION="A Perl extension interface to James Clark's XML parser, expat"

SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/expat-1.95.1-r1"
DEPEND="${RDEPEND}"

SRC_TEST=do

src_configure() {
	myconf="EXPATLIBPATH=${EPREFIX}/usr/$(get_libdir) EXPATINCPATH=${EPREFIX}/usr/include"
	perl-module_src_configure
}
