# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

MY_GDB_V=7.6

DESCRIPTION="Red Hat crash utility; used for analyzing kernel core dumps"
HOMEPAGE="https://crash-utility.github.io/"

# can't reuse sys-devel/gdb's gdb.tar.xz since build system expects a .tar.gz
SRC_URI="https://github.com/crash-utility/crash/archive/${PV}.tar.gz -> ${P}.tar.gz
	http://ftp.gnu.org/gnu/gdb/gdb-${MY_GDB_V}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~alpha ~amd64 ~arm ~ia64 ~ppc64 ~s390 ~x86"
IUSE=""
# there is no "make test" target, but there is a test.c so the automatic
# make rules catch it and tests fail
RESTRICT="test"

src_unpack() {
	unpack "${P}.tar.gz"
	cp "${DISTDIR}/gdb-${MY_GDB_V}.tar.gz" "${S}/"
}

src_prepare() {
	sed -i -e "s|ar -rs|\${AR} -rs|g" Makefile || die
	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
