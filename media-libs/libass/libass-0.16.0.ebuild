# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/libass.asc
inherit multilib-minimal verify-sig

DESCRIPTION="Library for SSA/ASS subtitles rendering"
HOMEPAGE="https://github.com/libass/libass"
SRC_URI="https://github.com/libass/libass/releases/download/${PV}/${P}.tar.xz"
SRC_URI+=" verify-sig? ( https://github.com/libass/libass/releases/download/${PV}/${P}.tar.xz.asc )"

LICENSE="ISC"
SLOT="0/9" # subslot = libass soname version
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="+fontconfig"

BDEPEND="virtual/pkgconfig
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	verify-sig? ( sec-keys/openpgp-keys-libass )"
RDEPEND=">=dev-libs/fribidi-0.19.5-r1[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-1.2.3:=[truetype,${MULTILIB_USEDEP}]
	fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

DOCS=( Changelog )

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable fontconfig) \
		--disable-require-system-font-provider
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -name '*.la' -type f -delete || die
}
