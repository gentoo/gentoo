# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdctl/cdctl-0.16.ebuild,v 1.1 2015/08/03 14:33:58 polynomial-c Exp $

EAPI=5

inherit eutils autotools toolchain-funcs

DESCRIPTION="Utility to control your cd/dvd drive"
HOMEPAGE="http://cdctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdctl/${P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.16-Makefile.in.patch

	eautoreconf
}

src_compile() {
	emake CC="$(tc-getCC)"
}
