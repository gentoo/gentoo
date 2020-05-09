# Copyright 1999-2020 Gentoo Authors
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

BDEPEND=">=app-eselect/eselect-iptables-20200508"
RDEPEND="${BDEPEND}"

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

	newman arptables-legacy.8 arptables.8
}

pkg_postinst() {
	if ! eselect arptables show &>/dev/null; then
		elog "Current arptables implementation is unset, setting to ebtables-legacy"
		eselect arptables set arptables-legacy
	fi

	eselect arptables show
}

pkg_prerm() {
	if has_version 'net-firewall/iptables[nftables]'; then
		elog "Resetting arptables symlinks to xtables-nft-multi before removal"
		eselect arptables set xtables-nft-multi
	else
		elog "Unsetting arptables symlinks before removal"
		eselect arptables unset
	fi
}
