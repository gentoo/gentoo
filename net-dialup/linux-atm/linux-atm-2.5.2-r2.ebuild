# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic linux-info

DESCRIPTION="Tools for ATM"
HOMEPAGE="https://linux-atm.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="sys-devel/bison"

RESTRICT="test"

CONFIG_CHECK="~ATM"

PATCHES=(
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-linux-5.2-SIOCGSTAMP.patch
	"${FILESDIR}"/${P}-linux-headers-5.19.patch
	"${FILESDIR}"/${P}-c99-musl.patch
	"${FILESDIR}"/${P}-remove-bad-define.patch
	"${FILESDIR}"/${P}-fix-booleans.patch
	"${FILESDIR}"/${P}-socklen-types.patch
	"${FILESDIR}"/${P}-fix-formatting.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	export YACC=bison
	econf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	dodoc doc/README* doc/atm*
}
