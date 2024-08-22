# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Telnet and telnetd ported from OpenBSD with IPv6 support"
HOMEPAGE="ftp://ftp.suse.com/pub/people/kukuk/ipv6/"
SRC_URI="https://dev.gentoo.org/~mschiff/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="nls selinux xinetd"

DEPEND="
	sys-libs/ncurses:=
	!net-misc/netkit-telnetd
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-telnet )
	xinetd? ( sys-apps/xinetd )
	!net-misc/netkit-telnetd
	!net-misc/inetutils[telnet(-)]
	!net-misc/inetutils[telnetd(-)]
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fbsd.patch
	"${FILESDIR}"/${PN}-1.2-format-security.patch
	"${FILESDIR}"/${P}-musl.patch
	"${FILESDIR}"/${P}-openpty-util.patch
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_install() {
	default

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/telnetd.xinetd telnetd
	fi
}
