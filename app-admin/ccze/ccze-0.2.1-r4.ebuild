# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fixheadtails autotools eutils toolchain-funcs

DESCRIPTION="A flexible and fast logfile colorizer"
HOMEPAGE="https://github.com/madhouse/ccze/releases"
SRC_URI="mirror://gentoo/${P}.tar.gz"

RESTRICT="test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

DEPEND="dev-libs/libpcre
	sys-libs/ncurses:0="

RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog ChangeLog-0.1 NEWS THANKS README FAQ )

PATCHES=(
	"${FILESDIR}"/ccze-fbsd.patch
	"${FILESDIR}"/ccze-segfault.patch
	"${FILESDIR}"/ccze-ldflags.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default

	# GCC 4.x fixes
	sed -e 's/-Wswitch -Wmulticharacter/-Wswitch/' \
	    -i src/Makefile.in || die
	sed -e '/AC_CHECK_TYPE(error_t, int)/d' \
	    -i configure.ac || die

	eautoreconf

	ht_fix_file Rules.mk.in

	tc-export CC
}
