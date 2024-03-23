# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://abiword.github.io/enchant/"
SRC_URI="https://github.com/AbiWord/enchant/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

IUSE="aspell +hunspell nuspell test voikko"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( aspell hunspell nuspell )"

COMMON_DEPEND="
	>=dev-libs/glib-2.6:2
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1:0= )
	nuspell? ( >=app-text/nuspell-5.1.0:0= )
	voikko? ( dev-libs/libvoikko:= )
"
RDEPEND="${COMMON_DEPEND}
	!<app-text/enchant-1.6.1-r2:0
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-libs/unittest++-2.0.0-r2 )
"
BDEPEND="
	sys-apps/groff
	virtual/pkgconfig
"

QA_CONFIG_IMPL_DECL_SKIP=(
	alignof
	static_assert
	unreachable
)

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable test relocatable)
		$(use_with aspell)
		$(use_with hunspell)
		$(use_with nuspell)
		$(use_with voikko)
		--without-hspell
		--without-applespell
		--without-zemberek
		--with-hunspell-dir="${EPREFIX}"/usr/share/hunspell/
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
