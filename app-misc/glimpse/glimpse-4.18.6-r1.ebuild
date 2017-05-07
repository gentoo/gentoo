# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="A index/query system to search a large set of files quickly"
HOMEPAGE="http://webglimpse.net/"
SRC_URI="http://webglimpse.net/trial/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="static"

RDEPEND="!dev-libs/tre
	!app-text/agrep"

PATCHES=( "${FILESDIR}/${PN}-4.18.6-makefile.patch" )

src_prepare() {
	sed -i \
		-e "s:CC=.*:CC=$(tc-getCC):" \
		-e 's:-O3 -fomit-frame-pointer:$(OPTIMIZEFLAGS):' \
		dynfilters/Makefile.in \
		|| die "removing -O3 failed"
	sed -i \
		-e '/^CFLAGS/s:$: $(OPTIMIZEFLAGS):' \
		{agrep,compress,index}/Makefile.in \
		libtemplate/{template,util}/Makefile.in \
		|| die "inserting OPTIMIZEFLAGS failed"
	sed -i \
		-e 's:$(mandir):&/man1/:' \
		agrep/Makefile.in \
		|| die "adding man1 to man install dir failed"

	sed -i \
		-e '/^LDFLAGS/d' \
		{agrep,compress,index}/Makefile.in \
		|| die "LDFLAGS sed failed"

	default
}

src_configure() {
	use static && append-ldflags -static
	default
}

src_compile() {
	# The OPTIMIZEFLAGS variable is our own, patched in...
	emake OPTIMIZEFLAGS="${CFLAGS}"
}

src_install() {
	# The build system is buggy; we get sandbox violations without this.
	emake prefix="${ED}/usr" install
}
