# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/x264/x264-0.0.20130506.ebuild,v 1.4 2014/07/31 14:34:47 klausman Exp $

EAPI=5

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="A free library for encoding X264/AVC streams"
HOMEPAGE="http://www.videolan.org/developers/x264.html"
if [[ ${PV} == 9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://git.videolan.org/x264.git"
	SLOT="0"
else
	inherit versionator
	MY_P="x264-snapshot-$(get_version_component_range 3)-2245"
	SRC_URI="http://download.videolan.org/pub/videolan/x264/snapshots/${MY_P}.tar.bz2"
	KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

	SONAME="132"
	SLOT="0/${SONAME}"

	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
IUSE="10bit custom-cflags +interlaced pic static-libs +threads"

ASM_DEP=">=dev-lang/yasm-1.2.0"
DEPEND="amd64? ( ${ASM_DEP} )
	amd64-fbsd? ( ${ASM_DEP} )
	x86? ( ${ASM_DEP} )
	x86-fbsd? ( ${ASM_DEP} )"

DOCS="AUTHORS doc/*.txt"

src_prepare() {
	# Initial support for x32 ABI, bug #420241
	epatch "${FILESDIR}"/x264-x32.patch
}

src_configure() {
	tc-export CC
	local asm_conf=""

	# let upstream pick the optimization level by default
	use custom-cflags || filter-flags -O?

	if use x86 && use pic || [[ ${ABI} == "x32" ]]; then
		asm_conf=" --disable-asm"
	fi

	./configure \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-cli \
		--disable-avs \
		--disable-lavf \
		--disable-swscale \
		--disable-ffms \
		--disable-gpac \
		--enable-pic \
		--enable-shared \
		--host="${CHOST}" \
		$(usex 10bit "--bit-depth=10" "") \
		$(usex interlaced "" "--disable-interlaced") \
		$(usex static-libs "" "--enable-static") \
		$(usex threads "" "--disable-thread") \
		${asm_conf} || die

	# this is a nasty workaround for bug #376925 as upstream doesn't like us
	# fiddling with their CFLAGS
	if use custom-cflags; then
		local cflags
		cflags="$(grep "^CFLAGS=" config.mak | sed 's/CFLAGS=//')"
		cflags="${cflags//$(get-flag O)/}"
		cflags="${cflags//-O? /$(get-flag O) }"
		cflags="${cflags//-g /}"
		sed -i "s:^CFLAGS=.*:CFLAGS=${cflags//:/\\:}:" config.mak
	fi
}
