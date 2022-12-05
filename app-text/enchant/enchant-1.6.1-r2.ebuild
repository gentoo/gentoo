# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV//./-}"
DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://abiword.github.io/enchant/"
SRC_URI="https://github.com/AbiWord/enchant/releases/download/${PN}-${MY_PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

IUSE="aspell +hunspell test"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( aspell hunspell )"

COMMON_DEPEND="
	>=dev-libs/glib-2.6:2
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1:0= )
"
RDEPEND="${COMMON_DEPEND}
	!<app-text/enchant-2.3.3:2
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-libs/unittest++-2.0.0-r2 )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-hunspell150_fix.patch
)

src_prepare() {
	default
	sed -e "s/build_zemberek=yes//" -i "${S}"/configure{.ac,} || die # bug 662484
}

src_configure() {
	local myconf=(
		--datadir="${EPREFIX}"/usr/share/enchant-1
		--disable-static
		$(use_enable aspell)
		$(use_enable hunspell myspell)
		--disable-hspell
		--disable-ispell
		--disable-uspell
		--disable-voikko
		--disable-zemberek
		--with-myspell-dir="${EPREFIX}"/usr/share/myspell/
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
