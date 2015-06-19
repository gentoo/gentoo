# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/sgb/sgb-20030623.ebuild,v 1.10 2012/06/07 21:47:16 zmedico Exp $

inherit eutils multilib

DESCRIPTION="Stanford GraphBase"
HOMEPAGE="ftp://labrea.stanford.edu/pub/sgb/"
SRC_URI="ftp://labrea.stanford.edu/pub/sgb/sgb-${PV:0:4}-${PV:4:2}-${PV:6:2}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""
DEPEND="|| ( >=dev-util/cweb-3.00 virtual/tex-base )"
S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/sgb-20030623-parallel-make-fix.patch
	epatch "${FILESDIR}"/sgb-20030623-destdir.patch
}

src_compile() {
	# bug #299028
	emake -j1 \
	CFLAGS="${CFLAGS}" \
	SGBDIR=/usr/share/${PN} \
	INCLUDEDIR=/usr/include/sgb \
	LIBDIR=/usr/$(get_libdir) \
	BINDIR=/usr/bin \
	CFLAGS="${CFLAGS}" \
	lib demos tests || die "Failed to build"
	#CWEBINPUTS=/usr/share/${PN}/cweb \
	#LDFLAGS="${LDFLAGS}" \
}

src_install() {
	dodir /usr/share/${PN} /usr/include/sgb /usr/lib /usr/bin /usr/share/${PN}/cweb
	emake \
	DESTDIR="${D}" \
	SGBDIR=/usr/share/${PN} \
	INCLUDEDIR=/usr/include/sgb \
	LIBDIR=/usr/$(get_libdir) \
	BINDIR=/usr/bin \
	CFLAGS="${CFLAGS}" \
	LDFLAGS="${LDFLAGS}" \
	CWEBINPUTS=/usr/share/${PN}/cweb \
	install \
	|| die "Failed to install"

	# we don't need no makefile
	rm "${D}"/usr/include/sgb/Makefile

	dodoc ERRATA README
}

src_test() {
	emake tests
}
