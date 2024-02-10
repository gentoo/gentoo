# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A thesaurus lib, tool, and database"
HOMEPAGE="https://sourceforge.net/projects/aiksaurus"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${P}-patches.txz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="gtk"

RDEPEND="gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}"
BDEPEND="gtk? ( virtual/pkgconfig )"

PATCHES=(
	"${WORKDIR}"/patches/${P}-gcc43.patch
	"${WORKDIR}"/patches/${P}-format-security.patch
	"${WORKDIR}"/patches/${P}-c++17.patch
	"${FILESDIR}"/aiksaurus-1.2.1-autoconf.patch
)

src_prepare() {
	default

	# Needed to make relink work on FreeBSD, without it won't install.
	# Also needed for a sane .so versionning there.
	#elibtoolize
	# Clang 16
	eautoreconf
}

src_configure() {
	filter-flags -fno-exceptions
	econf $(use_with gtk)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
