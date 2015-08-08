# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils fixheadtails toolchain-funcs

DEBIAN_PV="2"
MY_P="${P/-/_}"
DEBIAN_URI="mirror://debian/pool/main/${PN:0:1}/${PN}"
DEBIAN_PATCH="${MY_P}-${DEBIAN_PV}.diff.gz"
DEBIAN_SRC="${MY_P}.orig.tar.gz"
DESCRIPTION="display or set the kernel time variables"
HOMEPAGE="http://www.ibiblio.org/linsearch/lsms/adjtimex.html"
SRC_URI="${DEBIAN_URI}/${DEBIAN_PATCH}
	${DEBIAN_URI}/${DEBIAN_SRC}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

DEPEND="sys-apps/sed"
RDEPEND=""

src_prepare() {
	cd "${WORKDIR}"
	epatch "${DISTDIR}"/${DEBIAN_PATCH}
	cd "${S}"
	for i in debian/adjtimexconfig debian/adjtimexconfig.8 ; do
		sed -e 's|/etc/default/adjtimex|/etc/conf.d/adjtimex|' \
			-i.orig ${i}
		sed -e 's|^/sbin/adjtimex |/usr/sbin/adjtimex |' \
			-i.orig ${i}
	done
	epatch "${FILESDIR}"/${PN}-1.29-r1-gentoo-utc.patch
	ht_fix_file debian/adjtimexconfig
	sed -i \
		-e '/CFLAGS = -Wall -t/,/endif/d' \
		-e '/$(CC).* -o/s|$(CFLAGS)|& $(LDFLAGS)|g' \
		Makefile.in || die "sed Makefile.in"
}

src_configure() {
	tc-export CC
	default
}

src_install() {
	dodoc README* ChangeLog
	doman adjtimex.8 debian/adjtimexconfig.8
	dosbin adjtimex debian/adjtimexconfig
	newinitd "${FILESDIR}"/adjtimex.init adjtimex
}

pkg_postinst() {
	einfo "Please run adjtimexconfig to create the configuration file"
}
