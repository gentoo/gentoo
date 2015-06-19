# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/upx-bin/upx-bin-3.91.ebuild,v 1.1 2014/06/09 07:35:59 patrick Exp $

EAPI="5"

inherit pax-utils

MY_P="${PN/-bin}-${PV}"
DESCRIPTION="Ultimate Packer for eXecutables (binary version with proprietary NRV compression)"
HOMEPAGE="http://upx.sourceforge.net/"
SRC_URI="x86? ( http://upx.sourceforge.net/download/${MY_P}-i386_linux.tar.bz2 )
	amd64? ( http://upx.sourceforge.net/download/${MY_P}-amd64_linux.tar.bz2 )
	ppc? ( http://upx.sourceforge.net/download/${MY_P}-powerpc_linux.tar.bz2 )
	arm? ( http://upx.sourceforge.net/download/${MY_P}-armeb_linux.tar.bz2 )
	mips? ( http://upx.sourceforge.net/download/${MY_P}-mipsel_linux.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="strip"

RDEPEND="!app-arch/upx-ucl"

S="${WORKDIR}"

QA_PREBUILT="/opt/bin/upx"

src_install() {
	cd ${MY_P}*
	into /opt
	dobin upx
	pax-mark -m "${ED}"/opt/bin/upx
	doman upx.1
	dodoc upx.doc BUGS NEWS README* THANKS TODO
	dohtml upx.html
}
