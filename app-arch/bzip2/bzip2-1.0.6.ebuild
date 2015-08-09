# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs flag-o-matic

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="http://www.bzip.org/"
SRC_URI="http://www.bzip.org/${PV}/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="static"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.0.4-makefile-CFLAGS.patch
	epatch "${FILESDIR}"/${PN}-1.0.6-saneso.patch
	epatch "${FILESDIR}"/${PN}-1.0.4-man-links.patch #172986
	epatch "${FILESDIR}"/${PN}-1.0.2-progress.patch
	epatch "${FILESDIR}"/${PN}-1.0.3-no-test.patch
	epatch "${FILESDIR}"/${PN}-1.0.4-POSIX-shell.patch #193365

	# - Use right man path
	# - Generate symlinks instead of hardlinks
	# - pass custom variables to control libdir
	sed -i \
		-e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
		-e 's:ln -s -f $(PREFIX)/bin/:ln -s :' \
		-e 's:$(PREFIX)/lib:$(PREFIX)/$(LIBDIR):g' \
		Makefile || die
}

bemake() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		"$@" || die
}
src_compile() {
	bemake -f Makefile-libbz2_so all || die
	use static && append-flags -static
	bemake all || die
}

src_install() {
	emake PREFIX="${D}"/usr LIBDIR=$(get_libdir) install || die
	dodoc README* CHANGES bzip2.txt manual.*

	# Install the shared lib manually
	dolib.so libbz2.so.${PV} || die
	dosym libbz2.so.${PV} /usr/$(get_libdir)/libbz2.so || die
	dosym libbz2.so.${PV} /usr/$(get_libdir)/libbz2.so.${PV%%.*} || die
	gen_usr_ldscript -a bz2

	if ! use static ; then
		newbin bzip2-shared bzip2 || die
	fi

	# move "important" bzip2 binaries to /bin and use the shared libbz2.so
	dodir /bin
	mv "${D}"/usr/bin/b{zip2,zcat,unzip2} "${D}"/bin/ || die
	dosym bzip2 /bin/bzcat || die
	dosym bzip2 /bin/bunzip2 || die
}
