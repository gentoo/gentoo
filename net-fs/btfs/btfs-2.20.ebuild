# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit autotools python-r1

DESCRIPTION="a bittorrent filesystem based on FUSE"
HOMEPAGE="https://github.com/johang/btfs"
SRC_URI="https://github.com/johang/btfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND=">=sys-fs/fuse-2.8.0:0
	>=net-misc/curl-7.22.0
	dev-libs/boost:=
	>=net-libs/libtorrent-rasterbar-0.16.0:="
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	${PYTHON_DEPS}"

src_prepare() {
	default

	# don't install btplay via make
	sed -i '/^SUBDIRS =/s/scripts//' Makefile.am || die

	eautoreconf
}

src_install() {
	default
	python_foreach_impl python_doscript scripts/btplay
}
