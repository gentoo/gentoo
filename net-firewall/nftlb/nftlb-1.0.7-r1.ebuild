# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info autotools

DESCRIPTION="nftables load balancer"
HOMEPAGE="https://github.com/zevenet/nftlb"
SRC_URI="https://github.com/zevenet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-firewall/nftables:=[modern-kernel(+)]
	dev-libs/jansson:=
	dev-libs/libev:=
"
RDEPEND="${DEPEND}"

# tests need root access
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/nftlb-1.0-tests.patch"
	"${FILESDIR}/nftlb-1.0-musl.patch"
)

pkg_setup() {
	local CONFIG_CHECK="
		~NF_TABLES
		~NFT_NUMGEN
		~NFT_HASH
		~NF_NAT
		~IP_NF_NAT
	"

	linux-info_pkg_setup

	if kernel_is lt 4 19; then
		eerror "${PN} requires kernel version 4.19 or newer"
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_test() {
	pushd tests >/dev/null || die

	sed -e "s:/var/log/syslog:\"${T}/tests.log\":" \
		-i exec_tests.sh || die

	./exec_tests.sh || die "tests failed"

	popd >/dev/null || die
}
