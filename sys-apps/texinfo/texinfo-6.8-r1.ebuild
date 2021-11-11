# Copyright 1999-2021 Gentoo Authors
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls +standalone static"

RDEPEND="
	!=app-text/tetex-2*
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

PATCHES=(
	"${FILESDIR}/${P}-undo-gnulib-nonnul.patch"
	"${FILESDIR}/${P}-enable-Carp.patch"
)

src_prepare() {
	default

	if use prefix ; then
		sed -i -e '1c\#!/usr/bin/env sh' util/texi2dvi util/texi2pdf || die
		touch doc/{texi2dvi,texi2pdf,pdftexi2dvi}.1
	fi
}

src_configure() {
	# Respect compiler and CPPFLAGS/CFLAGS/LDFLAGS for Perl extensions. #622576
	local -x PERL_EXT_CC="$(tc-getCC)" PERL_EXT_CPPFLAGS="${CPPFLAGS}" PERL_EXT_CFLAGS="${CFLAGS}" PERL_EXT_LDFLAGS="${LDFLAGS}"

	use static && append-ldflags -static
	local myeconfargs=( $(use_enable nls) )

	if use standalone ; then
		myeconfargs+=(
			--without-external-libintl-perl
			--without-external-Unicode-EastAsianWidth
			--without-external-Text-Unidecode
			--disable-perl-xs
		)
	else
		myeconfargs+=(
			--with-external-libintl-perl
			--with-external-Unicode-EastAsianWidth
			--with-external-Text-Unidecode
			--enable-perl-xs
		)
	fi

	econf "${myeconfargs[@]}"
}
