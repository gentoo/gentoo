# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

MY_P="${PN}-${PV:0:4}-${PV:0-1}"
DESCRIPTION="POSIX man-pages (0p, 1p, 3p)"
HOMEPAGE="https://www.kernel.org/doc/man-pages/"
SRC_URI="mirror://kernel/linux/docs/man-pages/${PN}/${MY_P}.tar.xz"

LICENSE="man-pages-posix-2013"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""
RESTRICT="binchecks"

RDEPEND="virtual/man !<sys-apps/man-pages-3"

S=${WORKDIR}/${MY_P}

src_prepare() { :; }

src_configure() { :; }

src_compile() { :; }

src_install() {
	emake install DESTDIR="${ED}" || die
	dodoc man-pages-*.Announce README
}
