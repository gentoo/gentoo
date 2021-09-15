# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info toolchain-funcs

DESCRIPTION="A utility to interface to the kernel to monitor for dropped network packets"
HOMEPAGE="https://fedorahosted.org/dropwatch/"
SRC_URI="https://dev.gentoo.org/~bircoph/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libnl:3
	sys-libs/binutils-libs:=
	sys-libs/readline:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NET_DROP_MONITOR"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${PN}-1.4-binutils-2.23.patch"
)

src_compile() {
	tc-export PKG_CONFIG
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
