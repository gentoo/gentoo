# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils flag-o-matic

PATCHV="${P##*_p}"
MY_P="${P%%_*}"
MY_P="${MY_P/-/_}"

DESCRIPTION="PPM based compressor -- better behaved than bzip2"
HOMEPAGE="http://packages.qa.debian.org/p/ppmd.html"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}-${PATCHV}.diff.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="-alpha -amd64 hppa -ia64 ~mips ppc sparc x86 ~x86-interix -amd64-linux -ia64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=">=sys-apps/sed-4
	app-arch/gzip
	sys-devel/patch
	sys-devel/autoconf
	sys-devel/automake"
RDEPEND=""

S=${WORKDIR}/${PN}-i1

src_prepare() {
	epatch "${WORKDIR}/${MY_P}-${PATCHV}.diff"
	epatch "${S}/${MY_P/_/-}/debian/patches"/*.patch
	mv "${S}/b/Makefile" "${S}" || die "no makefile found"
	epatch "${FILESDIR}/${PN}-p10-makefile.patch"
}

src_configure() {
	replace-flags -O3 -O2
	append-flags -fno-inline-functions -fno-exceptions -fno-rtti
}

src_install() {
	emake -j1 install DESTDIR="${ED}" || die "failed installing"
	doman "${S}/${MY_P/_/-}/debian/ppmd.1" || die "failed installing manpage"
	dodoc "${S}/read_me.txt" || die "failed installed readme"
}
