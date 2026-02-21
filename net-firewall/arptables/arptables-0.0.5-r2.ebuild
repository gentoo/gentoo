# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/netfilter.org.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="Set up, maintain, and inspect the tables of ARP rules in the Linux kernel"
HOMEPAGE="https://ebtables.netfilter.org"
SRC_URI="
	https://ftp.netfilter.org/pub/${PN}/${P}.tar.gz
	verify-sig? ( https://ftp.netfilter.org/pub/${PN}/${P}.tar.gz.sig )
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

BDEPEND="
	>=app-eselect/eselect-iptables-20211203
	verify-sig? ( sec-keys/openpgp-keys-netfilter )
"
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
		elog "Current arptables implementation is unset, setting to arptables-legacy"
		eselect arptables set arptables-legacy
	fi

	eselect arptables show
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] && has_version 'net-firewall/iptables[nftables]'; then
		elog "Resetting arptables symlinks to xtables-nft-multi before removal"
		eselect arptables set xtables-nft-multi
	else
		elog "Unsetting arptables symlinks before removal"
		eselect arptables unset
	fi
}
