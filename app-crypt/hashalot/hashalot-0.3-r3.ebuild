# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Reads a passphrase and prints a hash"
HOMEPAGE="https://www.paranoiacs.org/~sluskyb/"
SRC_URI="https://www.paranoiacs.org/~sluskyb/hacks/hashalot/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~m68k ~mips ppc ppc64 ~s390 ~sparc x86"

src_prepare() {
	default

	# https://bugs.gentoo.org/900132
	eautoreconf
}
