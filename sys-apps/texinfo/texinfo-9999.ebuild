# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Note: if your package uses the texi2dvi utility, it must depend on the
# virtual/texi2dvi package to pull in all the right deps.  The tool is not
# usable out-of-the-box because it requires the large tex packages.

# Keep an eye on the release/$(ver_cut 1-2) branch upstream for backports.

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The GNU info program and utilities"
HOMEPAGE="https://www.gnu.org/software/texinfo/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/texinfo.git"
	REGEN_BDEPEND="
		>=dev-build/autoconf-2.62
		>=dev-build/automake-1.16
		dev-build/libtool
	"
elif [[ $(ver_cut 3) -ge 90 || $(ver_cut 4) -ge 90 ]] ; then
	SRC_URI="https://alpha.gnu.org/gnu/${PN}/${P}.tar.xz"
	REGEN_BDEPEND=""
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	REGEN_BDEPEND=""
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="nls +standalone static"

RDEPEND="
	>=sys-libs/ncurses-5.2-r2:=
	standalone? ( >=dev-lang/perl-5.8.1 )
	!standalone?  (
		>=dev-lang/perl-5.8.1:=
		dev-libs/libunistring:=
	)
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${REGEN_BDEPEND}
	nls? ( >=sys-devel/gettext-0.19.6 )
"

src_prepare() {
	default

	if [[ ${PV} == 9999 ]]; then
		./autogen.sh || die
	fi

	# Needed if a patch touches install-info.c
	#touch man/install-info.1 || die

	if use prefix ; then
		sed -i -e '1c\#!/usr/bin/env sh' util/texi2dvi util/texi2pdf || die
		touch {doc,man}/{texi2dvi,texi2pdf,pdftexi2dvi}.1 || die
	fi
}

src_configure() {
	# Respect compiler and CPPFLAGS/CFLAGS/LDFLAGS for Perl extensions
	# bug #622576
	local -x PERL_EXT_CC="$(tc-getCC)" PERL_EXT_CPPFLAGS="${CPPFLAGS}"
	local -x PERL_EXT_CFLAGS="${CFLAGS}" PERL_EXT_LDFLAGS="${LDFLAGS}"

	use static && append-ldflags -static

	# TODO:
	# --with-external-Unicode-EastAsianWidth
	# --with-external-Text-Unidecode
	# --enable-xs-perl-libintl for musl (7.2)?
	#
	# Also, 7.0.91 seemed to introduce a included-libunistring w/ USE=-standalone
	# but it doesn't seem to do anything?
	local myeconfargs=(
		--cache-file="${S}"/config.cache
		$(use_enable nls)
		$(use_enable !standalone perl-xs)
	)

	econf "${myeconfargs[@]}"
}
