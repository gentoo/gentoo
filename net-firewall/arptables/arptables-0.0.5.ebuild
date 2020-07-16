# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="set up, maintain, and inspect the tables of ARP rules in the Linux kernel"
HOMEPAGE="http://ebtables.sourceforge.net/"
SRC_URI="ftp://ftp.netfilter.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_compile() {
	# -O0 does not work and at least -O2 is required, bug #240752
	emake CC="$(tc-getCC)" COPT_FLAGS="-O2 ${CFLAGS//-O0/-O2}"
	sed -e 's:__EXEC_PATH__:/sbin:g' \
		-i arptables-save arptables-restore || die "sed failed"
}

src_install() {
	emake \
		PREFIX="${ED}"/ \
		LIBDIR="${ED}/$(get_libdir)" \
		SYSCONFIGDIR="${ED}"/etc \
		MANDIR="${ED}"/usr/share/man \
		install

	dosym arptables-legacy /sbin/arptables
	newman arptables-legacy.8 arptables.8
}
