# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="A TCP, UDP, and SCTP network bandwidth measurement tool"
HOMEPAGE="https://github.com/esnet/iperf"
SRC_URI="https://github.com/esnet/iperf/archive/${PV/_/}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P/_/}

LICENSE="BSD"
SLOT="3"
<<<<<<< HEAD
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
=======
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
>>>>>>> 3928948a06b (rebase)
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
	"${FILESDIR}"/${PN}-3.12-fix-bashism.patch
	"${FILESDIR}"/${PN}-3.12-Unbundle-cJSON.patch
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

	find "${ED}" -name '*.la' -delete || die
}
