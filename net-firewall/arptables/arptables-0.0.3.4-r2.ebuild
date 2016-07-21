# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit versionator eutils

MY_P=${PN}-v$(replace_version_separator 3 - )

DESCRIPTION="set up, maintain, and inspect the tables of ARP rules in the Linux kernel"
HOMEPAGE="http://ebtables.sourceforge.net/"
SRC_URI="mirror://sourceforge/ebtables/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-ldflags.patch"
	epatch "${FILESDIR}/${P}-arptables_save.patch"
	epatch "${FILESDIR}/${P}-manpage.patch"
	epatch "${FILESDIR}/${P}-type.patch"
}

src_compile() {
	# -O0 does not work and at least -O2 is required, bug #240752
	emake CC="$(tc-getCC)" COPT_FLAGS="-O2 ${CFLAGS//-O0/-O2}" || die "make failed"
	sed -ie 's:__EXEC_PATH__:/sbin:g' arptables-save arptables-restore \
		|| die "sed failed"
}

src_install() {
	into /
	dosbin arptables arptables-restore arptables-save || die
	doman arptables.8 || die
}
