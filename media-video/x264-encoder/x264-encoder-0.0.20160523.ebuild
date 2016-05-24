# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic multilib toolchain-funcs eutils

DESCRIPTION="A free commandline encoder for X264/AVC streams"
HOMEPAGE="http://www.videolan.org/developers/x264.html"
if [[ ${PV} == 9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://git.videolan.org/x264.git"
	SRC_URI=""
else
	inherit versionator
	MY_P="x264-snapshot-$(get_version_component_range 3)-2245"
	SRC_URI="http://download.videolan.org/pub/videolan/x264/snapshots/${MY_P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="10bit avs custom-cflags ffmpeg ffmpegsource +interlaced mp4 +threads"

REQUIRED_USE="ffmpegsource? ( ffmpeg )"

RDEPEND="ffmpeg? ( virtual/ffmpeg )
	~media-libs/x264-${PV}[10bit=,interlaced=,threads=]
	ffmpegsource? ( media-libs/ffmpegsource )
	mp4? ( >=media-video/gpac-0.5.2 )"

ASM_DEP=">=dev-lang/yasm-1.2.0"
DEPEND="${RDEPEND}
	amd64? ( ${ASM_DEP} )
	x86? ( ${ASM_DEP} )
	x86-fbsd? ( ${ASM_DEP} )
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/gpac.patch"
}

src_configure() {
	tc-export CC

	# let upstream pick the optimization level by default
	use custom-cflags || filter-flags -O?

	./configure \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--system-libx264 \
		--host="${CHOST}" \
		--disable-lsmash \
		$(usex 10bit "--bit-depth=10" "") \
		$(usex avs "" "--disable-avs") \
		$(usex ffmpeg "" "--disable-lavf --disable-swscale") \
		$(usex ffmpegsource "" "--disable-ffms") \
		$(usex interlaced "" "--disable-interlaced") \
		$(usex mp4 "" "--disable-gpac") \
		$(usex threads "" "--disable-thread") || die

	# this is a nasty workaround for bug #376925 for x264 that also applies
	# here, needed because as upstream doesn't like us fiddling with their CFLAGS
	if use custom-cflags; then
		local cflags
		cflags="$(grep "^CFLAGS=" config.mak | sed 's/CFLAGS=//')"
		cflags="${cflags//$(get-flag O)/}"
		cflags="${cflags//-O? /$(get-flag O) }"
		cflags="${cflags//-g /}"
		sed -i "s:^CFLAGS=.*:CFLAGS=${cflags//:/\\:}:" config.mak
	fi
}
