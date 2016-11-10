# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Manages the {,/usr}/bin/awk symlink"
HOMEPAGE="https://www.gentoo.org"
SRC_URI="https://dev.gentoo.org/~ottxor/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-macos"
IUSE=""

src_install() {
	insinto /usr/share/eselect/modules
	doins awk.eselect
}
