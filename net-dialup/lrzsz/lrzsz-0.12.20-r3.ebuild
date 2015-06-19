# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/lrzsz/lrzsz-0.12.20-r3.ebuild,v 1.12 2014/08/03 05:59:41 tgall Exp $

EAPI="2"

inherit autotools flag-o-matic eutils toolchain-funcs

DESCRIPTION="Communication package providing the X, Y, and ZMODEM file transfer protocols"
HOMEPAGE="http://www.ohse.de/uwe/software/lrzsz.html"
SRC_URI="http://www.ohse.de/uwe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="nls"

DEPEND="nls? ( virtual/libintl )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-autotools.patch
	epatch "${FILESDIR}"/${PN}-implicit-decl.patch
	epatch "${FILESDIR}"/${P}-automake-1.12.patch
	epatch "${FILESDIR}"/${P}-automake-1.13.patch

	# automake is unhappy if this is missing
	>> config.rpath
	# This is too old.  Remove it so automake puts in a newer copy.
	rm -f missing
	# Autoheader does not like seeing this file.
	rm -f acconfig.h

	eautoreconf
}

src_configure() {
	tc-export CC
	append-flags -Wstrict-prototypes
	econf $(use_enable nls) || die "econf failed"
}

src_test() {
	#Don't use check target.
	#See bug #120748 before changing this function.
	make vcheck || die "tests failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		install || die "make install failed"

	local x
	for x in {r,s}{b,x,z} ; do
		dosym l${x} /usr/bin/${x}
		dosym l${x:0:1}z.1 /usr/share/man/man1/${x}.1
		[ "${x:1:1}" = "z" ] || dosym l${x:0:1}z.1 /usr/share/man/man1/l${x}.1
	done

	dodoc AUTHORS COMPATABILITY ChangeLog NEWS README* THANKS TODO
}
