# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils multilib toolchain-funcs

PATCH_LEVEL=10

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="http://arj.sourceforge.net"
SRC_URI="mirror://debian/pool/main/a/arj/${P/-/_}.orig.tar.gz
	mirror://debian/pool/main/a/arj/${P/-/_}-${PATCH_LEVEL}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-implicit-declarations.patch \
		"${FILESDIR}/${P}-glibc2.10.patch"

	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" \
		epatch "${WORKDIR}"/debian/patches

	epatch "${FILESDIR}"/${P}-darwin.patch
	epatch "${FILESDIR}"/${P}-interix.patch

	cd gnu
	eautoconf
}

src_configure() {
	cd gnu
	CFLAGS="${CFLAGS} -Wall" econf
}

src_compile() {
	sed -i -e '/stripgcc/d' GNUmakefile || die "sed failed."

	ARJLIBDIR="${EPREFIX}/usr/$(get_libdir)"

	emake CC=$(tc-getCC) libdir="${ARJLIBDIR}" \
		ADD_LDFLAGS="${LDFLAGS}" \
		pkglibdir="${ARJLIBDIR}" all
}

src_install() {
	emake pkglibdir="${ARJLIBDIR}" DESTDIR="${D}" install

	dodoc doc/rev_hist.txt
}
