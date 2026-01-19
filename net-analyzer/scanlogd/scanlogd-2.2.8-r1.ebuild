# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openwall.asc
inherit savedconfig toolchain-funcs verify-sig

DESCRIPTION="A port scan detection tool"
HOMEPAGE="https://www.openwall.com/scanlogd/"
SRC_URI="
	https://www.openwall.com/scanlogd/${P}.tar.gz
	verify-sig? ( https://www.openwall.com/scanlogd/${P}.tar.gz.sign -> ${P}.tar.gz.sig )
"

LICENSE="scanlogd GPL-2" # GPL-2 for initscript
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="+nids pcap"
REQUIRED_USE="?? ( nids pcap )"

DEPEND="
	nids? ( net-libs/libnids )
	pcap? ( net-libs/libpcap )
"
RDEPEND="
	${DEPEND}
	acct-group/scanlogd
	acct-user/scanlogd
"
BDEPEND="sec-keys/openpgp-keys-openwall"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.7-gentoo.patch
)

src_prepare() {
	default

	restore_config params.h

	tc-export CC
}

src_compile() {
	local target=linux

	use nids && target=libnids
	use pcap && target=libpcap
	emake ${target}
}

src_install() {
	dosbin scanlogd

	doman scanlogd.8
	newinitd "${FILESDIR}"/scanlogd.rc scanlogd

	save_config params.h
}
