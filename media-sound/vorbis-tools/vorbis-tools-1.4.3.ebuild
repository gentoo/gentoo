# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools toolchain-funcs

DESCRIPTION="Tools for using the Ogg Vorbis sound file format"
HOMEPAGE="https://xiph.org/vorbis/"
SRC_URI="https://ftp.osuosl.org/pub/xiph/releases/vorbis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="flac kate +ogg123 speex"

RDEPEND="
	media-libs/libogg
	media-libs/libvorbis
	flac? ( media-libs/flac:= )
	kate? ( media-libs/libkate )
	ogg123? (
		media-libs/libao
		media-libs/opusfile
		net-misc/curl
		speex? ( media-libs/speex )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.3-docdir.patch
	"${FILESDIR}"/${PN}-1.4.3-unbundle_getopt.patch

	# updated by upstream in master #945288
	"${FILESDIR}"/${P}-unbundle_intl.patch

	# backport https://gitlab.xiph.org/xiph/vorbis-tools/-/merge_requests/27.patch
	"${FILESDIR}"/${P}-out-of-bounds.patch
	"${FILESDIR}"/${P}-fix_loop.patch
)

src_prepare() {
	default

	# updated by upstream in master #945288
	rm -r intl || die

	# use glibc/musl instead
	rm share/getopt{,1}.c include/getopt.h || die

	eautoreconf
}

src_configure() {
	# preliminary check with hardcoded pkg-config
	# then PKG_CHECK_MODULES from m4/pkg.m4 correctly handles PKG_CONFIG
	export ac_cv_prog_HAVE_PKG_CONFIG=yes
	tc-export PKG_CONFIG

	local myeconfargs=(
		$(use_with flac)
		$(use_with kate)
		$(use_enable ogg123)
		$(use_with speex)
	)
	econf "${myeconfargs[@]}"
}
