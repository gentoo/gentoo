# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd toolchain-funcs

DESCRIPTION="The Linux Precision Time Protocol (PTP) implementation"
HOMEPAGE="https://linuxptp.nwtime.org/"
SRC_URI="mirror://sourceforge/project/${PN}/v$(ver_cut 1-2)/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

DEPEND="elibc_musl? ( sys-libs/queue-standalone )"

CONFIG_CHECK="~NETWORK_PHY_TIMESTAMPING ~PPS ~PTP_1588_CLOCK"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2-user_cpp.patch
)

pkg_setup() {
	linux-info_pkg_setup
}

src_compile() {
	# parse needed additional CFLAGS
	export MY_FLAGS=$(CPP="$(tc-getCPP)" ./incdefs.sh)
	export EXTRA_CFLAGS="${CFLAGS} ${MY_FLAGS}"
	emake CC="$(tc-getCC)" prefix=/usr mandir=/usr/share/man
}

src_install() {
	emake \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		libdir="${D}"/usr/$(get_libdir) \
		install

	systemd_newunit "${FILESDIR}"/phc2sysAT.service phc2sys@.service
	systemd_newunit "${FILESDIR}"/ptp4lAT.service ptp4l@.service
	systemd_dounit "${FILESDIR}"/timemaster.service

	dodoc README.org
	dodoc -r configs
}
