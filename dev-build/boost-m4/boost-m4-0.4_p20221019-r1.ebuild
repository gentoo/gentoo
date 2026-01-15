# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BOOST_COMMIT="0c955e2c32804d6140676052a9e684ca84bf086d"

DESCRIPTION="Another set of autoconf macros for compiling against boost"
HOMEPAGE="https://github.com/tsuna/boost.m4"
SRC_URI="https://github.com/tsuna/boost.m4/archive/${BOOST_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN/-/.}-${BOOST_COMMIT}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

PATCHES=( "${FILESDIR}/${P}-boost-1.70-system-header-only.patch" )

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
