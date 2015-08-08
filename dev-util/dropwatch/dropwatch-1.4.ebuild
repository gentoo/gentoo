# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit linux-info toolchain-funcs

DESCRIPTION="A utility to interface to the kernel to monitor for dropped network packets"
HOMEPAGE="https://fedorahosted.org/dropwatch/"
SRC_URI="https://fedorahosted.org/releases/d/r/dropwatch/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libnl:3
	sys-libs/readline
	sys-devel/binutils"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NET_DROP_MONITOR"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${P}-binutils-2.23.patch"
)

src_prepare() {
	epatch ${PATCHES[@]}
	epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)" -C src
}

src_install() {
	dobin "src/${PN}"
	doman "doc/${PN}.1"
	dodoc README
}

pkg_postinst() {
	einfo "Ensure that 'drop_monitor' kernel module is loaded before running ${PN}"
}
