# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Note: if your package uses the texi2dvi utility, it must depend on the
# virtual/texi2dvi package to pull in all the right deps.  The tool is not
# usable out-of-the-box because it requires the large tex packages.

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The GNU info program and utilities"
HOMEPAGE="https://www.gnu.org/software/texinfo/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv s390 sparc ~x86"
IUSE="nls +standalone static"

RDEPEND="
	>=sys-libs/ncurses-5.2-r2:0=
	standalone? ( dev-lang/perl )
	!standalone?  (
		dev-lang/perl:=
		dev-perl/libintl-perl
		dev-perl/Unicode-EastAsianWidth
		dev-perl/Text-Unidecode
	)
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( >=sys-devel/gettext-0.19.6 )"

src_configure() {
	# Respect compiler and CPPFLAGS/CFLAGS/LDFLAGS for Perl extensions. #622576
	local -x PERL_EXT_CC="$(tc-getCC)" PERL_EXT_CPPFLAGS="${CPPFLAGS}" PERL_EXT_CFLAGS="${CFLAGS}" PERL_EXT_LDFLAGS="${LDFLAGS}"

	use static && append-ldflags -static
	local myeconfargs
	if use standalone ; then
		myeconfargs=(
			--without-external-libintl-perl
			--without-external-Unicode-EastAsianWidth
			--without-external-Text-Unidecode
			$(use_enable nls)
			--disable-perl-xs
		)
	else
		myeconfargs=(
			--with-external-libintl-perl
			--with-external-Unicode-EastAsianWidth
			--with-external-Text-Unidecode
			$(use_enable nls)
			--enable-perl-xs
		)
	fi
	econf "${myeconfargs[@]}"
}
