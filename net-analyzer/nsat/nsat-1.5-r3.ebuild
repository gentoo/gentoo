# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils toolchain-funcs

DESCRIPTION="Network Security Analysis Tool, an application-level network security scanner"
HOMEPAGE="http://nsat.sourceforge.net/"
SRC_URI="mirror://sourceforge/nsat/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="X"

RDEPEND="
	X? (
		x11-libs/libX11
		dev-lang/tk
	)
	dev-libs/libmix
	net-libs/libpcap
"
DEPEND="$RDEPEND"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch
	epatch "${FILESDIR}"/${P}-lvalue-gcc4.patch
	epatch "${FILESDIR}"/${P}-strip.patch
	epatch "${FILESDIR}"/${P}-misc.patch
	epatch "${FILESDIR}"/${P}-va_list.patch
	use amd64 && epatch "${FILESDIR}"/${P}-amd64-compat.patch

	sed -i \
		-e "s:^#CGIFile /usr/local/share/nsat/nsat.cgi$:#CGIFile /usr/share/nsat/nsat.cgi:g" \
		nsat.conf || die
	sed -i -e "s:/usr/local:/usr:g" tools/xnsat || die
	sed -i \
		-e "s:/usr/local/share/nsat/nsat.conf:/etc/nsat/nsat.conf:g" \
		-e "s:/usr/local/share/nsat/nsat.cgi:/usr/share/nsat/nsat.cgi:g" \
		src/lang.h || die

	eautoreconf
}

src_configure() {
	tc-export CC
	econf $(use_with X x)
}

src_compile() {
	emake MIXOBJ=-lmix++
}

src_install () {
	dobin nsat smb-ns
	use X && dobin tools/xnsat

	insinto /usr/share/nsat
	doins nsat.cgi

	insinto /etc/nsat
	doins nsat.conf

	dodoc README doc/CHANGES
	doman doc/nsat.8
}
