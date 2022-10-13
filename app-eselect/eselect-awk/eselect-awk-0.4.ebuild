# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages the {,/usr}/bin/awk symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://gitweb.gentoo.org/proj/eselect-awk.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux"

src_install() {
	insinto /usr/share/eselect/modules
	doins awk.eselect
}
