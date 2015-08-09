# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

MY_P="input-${PV/0.0.1_pre/}-101501"

DESCRIPTION="Small collection of linux input layer utils"
HOMEPAGE="http://dl.bytesex.org/cvs-snapshots/"
SRC_URI="http://dl.bytesex.org/cvs-snapshots/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/input"

src_prepare() {
	# Ported from Debian
	epatch "${FILESDIR}"/input-utils-0.0.1_pre20081014.patch
	# version check stuff
	epatch "${FILESDIR}"/input-utils-0.0.1-protocol-mismatch-fix.patch
}

src_install() {
	make install bindir="${D}"/usr/bin mandir="${D}"/usr/share/man STRIP="" || die "make install failed"
	dodoc lircd.conf
	dodoc README
}
