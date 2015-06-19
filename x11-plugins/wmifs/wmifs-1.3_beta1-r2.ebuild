# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmifs/wmifs-1.3_beta1-r2.ebuild,v 1.10 2010/09/09 10:01:48 s4t4n Exp $

inherit eutils

IUSE=""
MY_PV=${PV/_beta/b}
S=${WORKDIR}/wmifs.app/wmifs
DESCRIPTION="Network monitoring dock.app"
HOMEPAGE="http://www.linux.tucows.com"
SRC_URI="http://linux.tucows.tierra.net/files/x11/dock/${PN}-${MY_PV}.tar.gz
	http://http.us.debian.org/debian/pool/main/w/wmifs/${PN}_${MY_PV}-11.diff.gz"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha hppa ~mips ia64 amd64"

src_unpack()
{
	unpack ${A}
	cd "${S}"

	# patch to allow for longer interface names
	# and prettify program output for long names
	epatch "${WORKDIR}"/${PN}_${MY_PV}-11.diff

	# Honour Gentoo LDFLAGS, see bug #336537
	sed -i "s/-o wmifs/\$(LDFLAGS) -o wmifs/" Makefile
}

src_compile()
{
	emake CFLAGS="${CFLAGS}" || die
}

src_install ()
{
	dobin wmifs
	insinto /usr/share/wmifs
	doins sample.wmifsrc
	cd ..
	dodoc BUGS  CHANGES  HINTS  README  TODO
}
