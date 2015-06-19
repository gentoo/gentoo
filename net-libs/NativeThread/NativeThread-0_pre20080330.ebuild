# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/NativeThread/NativeThread-0_pre20080330.ebuild,v 1.2 2009/03/23 15:53:41 tommy Exp $

inherit eutils flag-o-matic java-pkg-2 toolchain-funcs

DESCRIPTION="NativeThread for priorities on linux for freenet"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-p2p/freenet-0.7
	>=virtual/jdk-1.4"
RDEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/Makefile.patch
}

src_compile() {
	append-flags -fPIC
	tc-export CC
	emake || die
}

src_install() {
	dolib.so lib${PN}.so || die
}
