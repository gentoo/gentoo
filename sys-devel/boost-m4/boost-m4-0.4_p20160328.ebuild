# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Another set of autoconf macros for compiling against boost"
HOMEPAGE="https://github.com/tsuna/boost.m4"
SRC_URI="https://dev.gentoo.org/~soap/distfiles/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""
S="${WORKDIR}/boost.m4-1489691f65aecb593e33abc3e56ac482dd67da7b"

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
