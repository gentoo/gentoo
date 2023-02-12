# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo

DESCRIPTION="Sleeplike program that counts down the number of seconds specified"
HOMEPAGE="https://onegeek.org/~tom/software/delay/"
SRC_URI="https://onegeek.org/~tom/software/delay/dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/byacc
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Our clang16 patch forces regeneration of the yacc files and going from
	# an ancient bison to a modern one makes 'delay until now + 5 minutes'
	# segfault. It happens even if the patch is empty, as the regeneration
	# is the breaking part. So, just force byacc, as it seems to work, and
	# this is a package with no active upstream.
	export YACC=byacc

	econf
}

src_test() {
	# No provided test suite, so let's add a smoketest which would've
	# caught the segfault part of bug #881319.
	edo ./delay 5
	edo ./delay until now + 1 minutes
}
