# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Command-line program for getting and setting the contents of the X selection"
HOMEPAGE="http://www.vergenet.net/~conrad/software/xsel"
SRC_URI="http://www.vergenet.net/~conrad/software/${PN}/download/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXt"

src_compile() {
	emake CFLAGS="${CFLAGS}"
}
