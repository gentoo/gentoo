# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib

DESCRIPTION="old berk db kept around for really old packages"
HOMEPAGE="http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html"
SRC_URI="http://download.oracle.com/berkeley-db/db.${PV}.tar.gz
		 mirror://gentoo/${P}-r3.1.patch.bz2"
# The patch used by Gentoo is from Fedora, and includes all 5 patches found on
# the Oracle page, plus others.

LICENSE="Sleepycat"
SLOT="1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""

S="${WORKDIR}/db.${PV}"

PATCHES=(
	"${WORKDIR}"/${P}-r3.1.patch
	"${FILESDIR}"/${P}-gentoo-paths.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:@GENTOO_LIBDIR@:$(get_libdir):" \
		PORT/linux/Makefile || die
}

src_compile() {
	tc-export CC AR RANLIB
	emake -C PORT/linux OORG="${CFLAGS}"
}

src_install() {
	make -C PORT/linux install DESTDIR="${ED}" || die

	# binary compat symlink
	dosym libdb1.so.2 /usr/$(get_libdir)/libdb.so.2

	sed -e "s:<db.h>:<db1/db.h>:" \
		-i "${ED}"/usr/include/db1/ndbm.h || die
	dosym db1/ndbm.h /usr/include/ndbm.h

	dodoc changelog README
	newdoc hash/README README.hash
	docinto ps
	dodoc docs/*.ps
}
