# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit vcs-snapshot

DESCRIPTION="Another set of autoconf macros for compiling against boost"
HOMEPAGE="https://github.com/tsuna/boost.m4"
SRC_URI="${HOMEPAGE}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

# boost.m4 has a buildsystem, but the distributer didn't use make dist
# so we'd have to eautoreconf to use it. Also, its ./configure script
# DEPENDs on boost. For installing one file, bootstrapping the
# buildsystem isn't worth it.
src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/aclocal
	doins build-aux/boost.m4

	dodoc AUTHORS NEWS README THANKS
}
