# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools eutils flag-o-matic toolchain-funcs

DESCRIPTION="A collection of tools for network auditing and penetration testing"
HOMEPAGE="http://monkey.org/~dugsong/dsniff/"
SRC_URI="http://monkey.org/~dugsong/${PN}/beta/${P/_beta/b}.tar.gz
	mirror://debian/pool/main/d/${PN}/${PN}_2.4b1+debian-18.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"

DEPEND="net-libs/libpcap
	>=net-libs/libnet-1.1.2.1-r1
	>=net-libs/libnids-1.21
	>=dev-libs/openssl-0.9.6e
	>=sys-libs/db-4.2.52_p4
	sys-apps/sed
	X? ( x11-libs/libXmu )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/_beta1/}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Debian's patchset
	epatch "${DISTDIR}"/${PN}_2.4b1+debian-18.diff.gz
	epatch "${S}"/dsniff-2.4b1+debian/debian/patches/*.dpatch

	sed -i 's:-DDSNIFF_LIBDIR=\\\"$(libdir)/\\\"::' Makefile.in || die "sed makefile"
	epatch "${FILESDIR}"/2.3-makefile.patch

	# Bug 125084
	epatch "${FILESDIR}"/${PV}-httppostfix.patch

	eautoreconf
}

src_compile() {
	econf \
		$(use_with X x) \
		|| die "econf failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake install install_prefix="${D}" || die "emake install failed"
	dodir /etc/dsniff
	cp "${D}"/usr/share/dsniff/{dnsspoof.hosts,dsniff.{magic,services}} \
		"${D}"/etc/dsniff/
	dodoc CHANGES README TODO
}
