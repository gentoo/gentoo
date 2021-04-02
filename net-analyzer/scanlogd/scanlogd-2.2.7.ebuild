# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit savedconfig toolchain-funcs user

DESCRIPTION="A port scan detection tool"
SRC_URI="http://www.openwall.com/scanlogd/${P}.tar.gz"
HOMEPAGE="http://www.openwall.com/scanlogd/"

LICENSE="scanlogd GPL-2" # GPL-2 for initscript
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="+nids pcap"
REQUIRED_USE="?? ( nids pcap )"

DEPEND="
	nids? ( net-libs/libnids )
	pcap? ( net-libs/libpcap )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
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

pkg_preinst() {
	enewgroup scanlogd
	enewuser scanlogd -1 -1 /dev/null scanlogd
}
