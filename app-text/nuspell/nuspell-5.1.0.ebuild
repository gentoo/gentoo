# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Spell checker library and CLI for complex natural languages"
HOMEPAGE="https://nuspell.github.io/ https://github.com/nuspell/nuspell"
SRC_URI="https://github.com/nuspell/nuspell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0/5"  # due to libnuspell.so.5
KEYWORDS="amd64 ~riscv x86"
IUSE="doc test"

RDEPEND=">=dev-libs/icu-60"
DEPEND="${RDEPEND}
	doc? ( app-text/pandoc )
	test? ( >=dev-cpp/catch-2.3.0:0 )
	"

DOCS=( CHANGELOG.md )

RESTRICT="!test? ( test )"

src_prepare() {
	rm -R external/Catch2/ || die
	if ! use test ; then
		rm -R external/hunspell/ || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

pkg_postinst() {
	einfo
	einfo 'Nuspell needs language packs and/or dictionaries to be of use'
	einfo 'e.g. package app-dicts/myspell-en or one of its siblings.'
	einfo
	einfo 'Besides MySpell dictionaries, for other options please'
	einfo 'see https://nuspell.github.io/#languages-and-users .'
	einfo
}
