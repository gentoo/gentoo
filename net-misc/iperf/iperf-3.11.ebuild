# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A TCP, UDP, and SCTP network bandwidth measurement tool"
HOMEPAGE="https://github.com/esnet/iperf"
SRC_URI="https://github.com/esnet/iperf/archive/${PV/_/}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P/_/}

LICENSE="BSD"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="sctp"

DEPEND="dev-libs/openssl:=
	sctp? ( net-misc/lksctp-tools )"
RDEPEND="${DEPEND}"

DOCS=( README.md RELNOTES.md )

PATCHES=(
	"${FILESDIR}"/${PN}-3.10.1-drop-forced-debugging-symbols.patch
)

src_configure() {
	econf $(use_with sctp)
}

src_install() {
	default

	newconfd "${FILESDIR}"/iperf.confd iperf3
	newinitd "${FILESDIR}"/iperf3.initd iperf3
	systemd_dounit contrib/iperf3.service

	find "${ED}" -name '*.la' -delete || die
}
