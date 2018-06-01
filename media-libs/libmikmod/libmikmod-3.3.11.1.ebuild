# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils multilib-minimal

DESCRIPTION="A library to play a wide range of module formats"
HOMEPAGE="http://mikmod.sourceforge.net/"
SRC_URI="mirror://sourceforge/mikmod/${P}.tar.gz"

LICENSE="LGPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+alsa altivec coreaudio debug nas openal oss pulseaudio cpu_flags_x86_sse2 static-libs +threads"

REQUIRED_USE="|| ( alsa coreaudio nas openal oss pulseaudio )"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2:=[${MULTILIB_USEDEP}] )
	nas? ( >=media-libs/nas-1.9.4:=[${MULTILIB_USEDEP}] )
	openal? ( >=media-libs/openal-1.15.1-r1[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-5.0[${MULTILIB_USEDEP}] )
	!${CATEGORY}/${PN}:2"
DEPEND="${RDEPEND}
	sys-apps/texinfo
	oss? ( virtual/os-headers )"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/libmikmod-config
)

src_prepare() {
	# USE=debug enables Werror, bug #621688
	sed -i -e 's/-Werror//' configure || die
	default
}

multilib_src_configure() {
	local mysimd="--disable-simd"
	if use ppc || use ppc64 || use ppc-macos; then
		mysimd="$(use_enable altivec simd)"
	fi
	if use amd64 || use x86 || use x86-fbsd || use amd64-linux || use x86-linux || use x86-macos || use x64-macos; then
		mysimd="$(use_enable cpu_flags_x86_sse2 simd)"
	fi

	# sdl, sdl2: missing multilib supported ebuilds, temporarily disabled, remember to update REQUIRED_USE
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable alsa) \
		$(use_enable nas) \
		$(use_enable pulseaudio) \
		--disable-sdl \
		--disable-sdl2 \
		$(use_enable openal) \
		$(use_enable oss) \
		$(use_enable coreaudio osx) \
		$(use_enable debug) \
		$(use_enable threads) \
		$(use_enable static-libs static) \
		--disable-dl \
		${mysimd}
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	dosym ${PN}$(get_libname 3) /usr/$(get_libdir)/${PN}$(get_libname 2)
}

multilib_src_install_all() {
	dodoc AUTHORS NEWS README TODO
	docinto html
	dodoc docs/*.html
	prune_libtool_files
}
