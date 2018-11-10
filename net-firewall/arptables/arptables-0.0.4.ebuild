# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P="${PN}-v${PV}"

DESCRIPTION="set up, maintain, and inspect the tables of ARP rules in the Linux kernel"
HOMEPAGE="http://ebtables.sourceforge.net/"
SRC_URI="ftp://ftp.netfilter.org/pub/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	# -O0 does not work and at least -O2 is required, bug #240752
	emake CC="$(tc-getCC)" COPT_FLAGS="-O2 ${CFLAGS//-O0/-O2}"
	sed -ie 's:__EXEC_PATH__:/sbin:g' arptables-save arptables-restore \
		|| die "sed failed"
}

src_install() {
	into /
	dosbin arptables arptables-restore arptables-save
	doman arptables.8
}
