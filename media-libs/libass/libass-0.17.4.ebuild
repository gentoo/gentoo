# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# meson support exists but README suggests not using it for packaging yet
# https://github.com/libass/libass/blob/master/README.md#building
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libass.asc
inherit multilib-minimal verify-sig

DESCRIPTION="Library for SSA/ASS subtitles rendering"
HOMEPAGE="https://github.com/libass/libass"
SRC_URI="https://github.com/libass/libass/releases/download/${PV}/${P}.tar.xz"
SRC_URI+=" verify-sig? ( https://github.com/libass/libass/releases/download/${PV}/${P}.tar.xz.asc )"

LICENSE="ISC"
SLOT="0/9" # subslot = libass soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos"
IUSE="+fontconfig libunibreak test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/fribidi-0.19.5-r1[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-1.2.3:=[truetype,${MULTILIB_USEDEP}]
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	libunibreak? ( dev-libs/libunibreak:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	test? ( media-libs/libpng[${MULTILIB_USEDEP}] )
	verify-sig? ( >=sec-keys/openpgp-keys-libass-20250608 )
"

DOCS=( Changelog )

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable fontconfig)
		$(multilib_native_use_enable libunibreak)
		$(use_enable test)
		--disable-require-system-font-provider
		# https://github.com/libass/libass/blob/bbb3c7f1570a4a021e52683f3fbdf74fe492ae84/Changelog#L111
		--with-pic
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -name '*.la' -type f -delete || die
}
