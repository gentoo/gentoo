# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/nhorman/${PN}.git"

inherit autotools git-r3 linux-info

DESCRIPTION="Monitor for dropped network packets"
HOMEPAGE="https://github.com/nhorman/dropwatch"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bfd"

RDEPEND="dev-libs/libnl:3
	net-libs/libpcap
	sys-libs/readline:=
	bfd? ( sys-libs/binutils-libs:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~NET_DROP_MONITOR"

src_prepare() {
	default

	sed -i '/AM_CFLAGS/s/-Werror //' src/Makefile.am \
		|| die "sed failed for Makefile.am"

	eautoreconf
}

src_configure() {
	econf "$(use_with bfd)"
}
