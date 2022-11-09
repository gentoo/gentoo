# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BINPKG="${P/-bin/}-1"

DESCRIPTION="Open Source implementation of a 16-bit x86 BIOS"
HOMEPAGE="https://www.seabios.org/"
SRC_URI="https://dev.gentoo.org/~ajak/distfiles/${BINPKG}.xpak"
S="${WORKDIR}"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="!sys-firmware/seabios"

src_unpack() {
	tar -x < <(xz -c -d --single-stream "${DISTDIR}/${BINPKG}.xpak") || die "unpacking binpkg failed"
}

src_install() {
	mv usr "${ED}" || die
}
