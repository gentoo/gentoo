# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="Library for SSA/ASS subtitles rendering"
HOMEPAGE="https://github.com/libass/libass"
SRC_URI="https://github.com/libass/libass/releases/download/${PV}/${P}.tar.xz"

LICENSE="ISC"
SLOT="0/9" # subslot = libass soname version
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="+fontconfig +harfbuzz static-libs"

RDEPEND="fontconfig? ( >=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}] )
	>=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-0.19.5-r1[${MULTILIB_USEDEP}]
	harfbuzz? ( >=media-libs/harfbuzz-0.9.12[truetype,${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

X86_CPU_OPTS="abi_x86_32 abi_x86_64"
for i in ${X86_CPU_OPTS} ; do
	DEPEND="${DEPEND}
		${i}? ( dev-lang/nasm )"
done

DOCS="Changelog"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable fontconfig) \
		$(use_enable harfbuzz) \
		$(use_enable static-libs static) \
		--disable-require-system-font-provider
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}
