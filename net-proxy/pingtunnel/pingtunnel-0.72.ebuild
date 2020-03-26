# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tunnel TCP over ICMP"
HOMEPAGE="https://www.cs.uit.no/~daniels/PingTunnel"
SRC_URI="https://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="selinux"

RDEPEND="
	net-libs/libpcap
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/PingTunnel

PATCHES=(
	"${FILESDIR}"/${P}_makefile.patch
	"${FILESDIR}"/${P}-musl.patch
)
HTML_DOCS=( web/. )

src_configure() {
	tc-export CC
}

src_compile() {
	emake SELINUX=$(usex selinux 1 0)
}
