# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Note: if your package uses the texi2dvi utility, it must depend on the
# virtual/texi2dvi package to pull in all the right deps.  The tool is not
# usable out-of-the-box because it requires the large tex packages.

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The GNU info program and utilities"
HOMEPAGE="https://www.gnu.org/software/texinfo/"

if [[ $(ver_cut 3) -ge 90 ]] ; then
	SRC_URI="https://alpha.gnu.org/gnu/${PN}/${P}.tar.xz"
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="nls +standalone static"

RDEPEND="
	!=app-text/tetex-2*
	>=sys-libs/ncurses-5.2-r2:=
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	standalone? ( >=dev-lang/perl-5.8.1 )
	!standalone?  ( >=dev-lang/perl-5.8.1:= )
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( >=sys-devel/gettext-0.19.6 )"

src_prepare() {
	default

	if use prefix ; then
		sed -i -e '1c\#!/usr/bin/env sh' util/texi2dvi util/texi2pdf || die
		touch doc/{texi2dvi,texi2pdf,pdftexi2dvi}.1
	fi
}

src_configure() {
	# Respect compiler and CPPFLAGS/CFLAGS/LDFLAGS for Perl extensions
	# bug #622576
	local -x PERL_EXT_CC="$(tc-getCC)" PERL_EXT_CPPFLAGS="${CPPFLAGS}"
	local -x PERL_EXT_CFLAGS="${CFLAGS}" PERL_EXT_LDFLAGS="${LDFLAGS}"

	use static && append-ldflags -static

	local myeconfargs=(
		--cache-file="${S}"/config.cache
		$(use_enable nls)
		$(use_enable !standalone perl-xs)
	)

	econf "${myeconfargs[@]}"
}
