# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://abiword.github.io/enchant/"
SRC_URI="https://github.com/AbiWord/enchant/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

IUSE="aspell +hunspell test voikko"
REQUIRED_USE="|| ( hunspell aspell )"

RDEPEND="
	>=dev-libs/glib-2.6:2
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1:0= )
	voikko? ( dev-libs/libvoikko )"
DEPEND="${RDEPEND}
	test? ( >=dev-libs/unittest++-2.0.0-r2 )"
BDEPEND="virtual/pkgconfig"

RESTRICT="test" # Tests fail

src_configure() {
	# TODO: Add app-text/nuspell support
	econf \
		--datadir="${EPREFIX}"/usr/share/enchant-2 \
		--disable-static \
		$(use_enable test relocatable) \
		$(use_with aspell) \
		$(use_with hunspell) \
		$(use_with voikko) \
		--without-nuspell \
		--without-hspell \
		--without-applespell \
		--without-zemberek \
		--with-hunspell-dir="${EPREFIX}"/usr/share/hunspell/
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
