# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="TCP, UDP, and SCTP network bandwidth measurement tool"
HOMEPAGE="https://software.es.net/iperf/ https://github.com/esnet/iperf"
SRC_URI="https://github.com/esnet/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="sctp"

DEPEND="
	>=dev-libs/cJSON-1.7.15
	dev-libs/openssl:=
	sctp? ( net-misc/lksctp-tools )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README.md RELNOTES.md )

PATCHES=(
	"${FILESDIR}"/${PN}-3.10.1-drop-forced-debugging-symbols.patch
	"${FILESDIR}"/${PN}-3.18-unbundle-cJSON.patch
)

src_prepare() {
	default

	# Drop bundled cjson
	rm src/cjson.{c,h} || die

	eautoreconf
}

src_configure() {
	econf $(use_with sctp)
}

src_install() {
	default

	newconfd "${FILESDIR}"/iperf.confd iperf3
	newinitd "${FILESDIR}"/iperf3.initd iperf3
	systemd_dounit contrib/iperf3.service

	find "${ED}" -name '*.la' -type f -delete || die
}
