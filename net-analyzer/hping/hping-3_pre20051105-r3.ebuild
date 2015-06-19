# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/hping/hping-3_pre20051105-r3.ebuild,v 1.8 2015/03/25 16:04:36 jlec Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs

MY_P="${PN}${PV//_pre/-}"
DESCRIPTION="A ping-like TCP/IP packet assembler/analyzer"
HOMEPAGE="http://www.hping.org"
SRC_URI="http://www.hping.org/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc sparc x86"
IUSE="tcl"

S="${WORKDIR}/${MY_P}"

DEPEND="net-libs/libpcap
	tcl? ( dev-lang/tcl:0 )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}.patch \
		"${FILESDIR}"/bytesex.h.patch \
		"${FILESDIR}"/${P}-tcl.patch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-libtcl.patch \
		"${FILESDIR}"/${P}-scan-overflow.patch

	# Correct hard coded values
	sed -i Makefile.in \
		-e '/^CC=/d' \
		-e '/^AR=/d' \
		-e '/^RANLIB=/d' \
		-e 's:/usr/local/lib:/usr/$(LIBDIR):g' \
		-e 's:-O2:$(CFLAGS):' \
		|| die "sed Makefile.in failed"

	# Change name from hping2 to hping3
	sed -i docs/hping3.8 \
		-e 's|HPING2|HPING|g' \
		-e 's|hping2|hping|g' \
		|| die "sed hping3.8 failed"
}

src_configure() {
	tc-export CC

	# Not an autotools type configure:
	sh configure $(use tcl || echo --no-tcl) || die "configure failed"
}

src_compile() {
	emake \
		DEBUG="" \
		"CFLAGS=${CFLAGS}" \
		"AR=$(tc-getAR)" \
		"RANLIB=$(tc-getRANLIB)" \
		"LIBDIR=$(get_libdir)" \
		|| die "emake failed"
}

src_install () {
	dosbin hping3
	dosym /usr/sbin/hping3 /usr/sbin/hping
	dosym /usr/sbin/hping3 /usr/sbin/hping2

	newman docs/hping3.8 hping.8

	dodoc INSTALL NEWS README TODO AUTHORS BUGS CHANGES
}
