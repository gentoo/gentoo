# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://github.com/rrthomas/enchant"
SRC_URI="https://github.com/rrthomas/enchant/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

IUSE="aspell +hunspell nuspell test voikko"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( aspell hunspell nuspell )"

COMMON_DEPEND="
	>=dev-libs/glib-2.76:2
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1:0= )
	nuspell? ( >=app-text/nuspell-5.1.0:0= )
	voikko? ( dev-libs/libvoikko:= )
"
RDEPEND="${COMMON_DEPEND}
	!<app-text/enchant-1.6.1-r2:0
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-libs/unittest++-2.0.0-r4 )
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

	# Force re-generation of Vala files
	#
	# TODO: Restore this, we can't currently because it relies on
	# an unmerged binding (locale_from_utf8)
	# See https://gitlab.gnome.org/GNOME/vala/-/merge_requests/391
	#vala_setup
	#find . -name '*.vala' -exec touch {} + || die

	elibtoolize
}

src_configure() {
	local myconf=(
		--disable-gcc-warnings
		$(use_enable test relocatable)
		$(use_with aspell)
		$(use_with hunspell)
		$(use_with nuspell)
		$(use_with voikko)
		--without-hspell
		--without-applespell
		--without-zemberek
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
