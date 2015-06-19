# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/uudeview/uudeview-0.5.20-r1.ebuild,v 1.6 2010/04/06 01:29:35 abcd Exp $

EAPI="3"

inherit eutils autotools

DESCRIPTION="uu, xx, base64, binhex decoder"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="tk"

RDEPEND="tk? ( dev-lang/tk )"

DEPEND="${RDEPEND}
	sys-devel/autoconf"

src_prepare() {
	epatch "${FILESDIR}/${P}-bugfixes.patch"
	epatch "${FILESDIR}/${P}-CVE-2004-2265.patch"
	epatch "${FILESDIR}/${P}-CVE-2008-2266.patch"
	epatch "${FILESDIR}/${P}-man.patch"
	epatch "${FILESDIR}/${P}-rename.patch"

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable tk tcl) \
		$(use_enable tk)
}

src_install() {
	# upstream's Makefiles are just broken
	einstall MANDIR="${ED}/usr/share/man/" || die "Failed to install"
	dodoc HISTORY INSTALL README
}
