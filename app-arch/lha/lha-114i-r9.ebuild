# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

MY_P="${PN}-1.14i-ac20050924p1"

DESCRIPTION="Utility for creating and opening lzh archives"
HOMEPAGE="https://lha.osdn.jp https://github.com/jca02266/lha"
SRC_URI="mirror://sourceforge.jp/${PN}/22231/${MY_P}.tar.gz"

LICENSE="lha"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~m68k-mint"
RESTRICT="bindist"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-file-list-from-stdin.patch
	"${FILESDIR}"/${P}-fix-getopt_long-declaration.patch
)

src_prepare() {
	default

	sed -e '/^AM_C_PROTOTYPES/d' \
		-e 's/^AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' \
		-i configure.ac || die #423125, 467544

	eautoreconf
}

src_configure() {
	append-cppflags -DPROTOTYPES #423125

	if [[ ${CHOST} == *-interix* ]]; then
		export ac_cv_header_inttypes_h=no
		export ac_cv_func_iconv=no
	fi

	econf
}

src_install() {
	emake \
		DESTDIR="${D}" \
		mandir="${EPREFIX}"/usr/share/man/ja \
		install

	dodoc ChangeLog Hacking_of_LHa
}
