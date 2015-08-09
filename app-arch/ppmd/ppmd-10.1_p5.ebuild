# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs

PATCHV="${P##*_p}"
MY_P="${P%%_*}"
MY_P="${MY_P/-/_}"

DESCRIPTION="PPM based compressor -- better behaved than bzip2"
HOMEPAGE="http://packages.qa.debian.org/p/ppmd.html"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}-${PATCHV}.debian.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="-alpha -amd64 ~hppa -ia64 ~mips ~ppc ~sparc ~x86 ~x86-interix -amd64-linux -ia64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

S="${WORKDIR}/${P%%_*}"

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX=patch epatch "${WORKDIR}"/debian/patches/
	epatch "${FILESDIR}/${PN}-p10-makefile.patch"
	sed b/Makefile \
		-e 's|$(CXX)|& $(CFLAGS) $(LDFLAGS)|g' > Makefile \
		|| die "sed b/Makefile"
}

src_configure() {
	tc-export CXX
	replace-flags -O3 -O2
	append-flags -fno-inline-functions -fno-exceptions -fno-rtti
}

src_install() {
	emake -j1 install DESTDIR="${ED}"
	doman "${WORKDIR}/debian/ppmd.1"
	dodoc "read_me.txt"
}
