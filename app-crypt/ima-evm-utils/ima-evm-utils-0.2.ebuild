# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

DESCRIPTION="Supporting tools for IMA and EVM"
HOMEPAGE="http://linux-ima.sourceforge.net"
SRC_URI="mirror://sourceforge/linux-ima/${P}.tar.gz"

DEPEND="sys-apps/keyutils"
RDEPEND="${DEPEND}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -i 's:pkglib_PROGRAMS:pkglibexec_PROGRAMS:g' tests/Makefile.am
	sed -i 's:pkglib_SCRIPTS:pkglibexec_SCRIPTS:g' tests/Makefile.am
	eautoreconf
}

src_configure() {
	econf || die
}

src_install() {
	emake install DESTDIR="${D}" || die
}
