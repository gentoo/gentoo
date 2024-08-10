# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-${PV:0:4}-${PV:0-1}"
DESCRIPTION="POSIX man-pages (0p, 1p, 3p)"
HOMEPAGE="https://www.kernel.org/doc/man-pages/"
SRC_URI="https://www.kernel.org/pub/linux/docs/man-pages/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}/${PN}-${PV:0:4}"

LICENSE="freedist" # to be clarified, see bug 871636
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RESTRICT="binchecks"

RDEPEND="virtual/man !<sys-apps/man-pages-3"

src_configure() { :; }

src_compile() { :; }

src_install() {
	emake install DESTDIR="${ED}"
	dodoc man-pages-*.Announce README
}
