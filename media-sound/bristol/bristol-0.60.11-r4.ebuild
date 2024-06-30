# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Synthesizer keyboard emulation package: Moog, Hammond and others"
HOMEPAGE="https://sourceforge.net/projects/bristol/"
SRC_URI="https://downloads.sourceforge.net/bristol/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa oss"
# osc : configure option but no code it seems...
# jack: fails to build if disabled
# pulseaudio: not fully supported

BDEPEND="
	virtual/pkgconfig"
RDEPEND="
	virtual/jack
	x11-libs/libX11
	alsa? ( media-libs/alsa-lib )"
# osc? ( >=media-libs/liblo-0.22 )
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-dontcompress.patch
	"${FILESDIR}"/${P}-rm_alsa-iatomic.h.patch
	"${FILESDIR}"/bristol-c99.patch
	"${FILESDIR}"/0001-configure.ac-fix-various-erroneous-bashisms.patch
	"${FILESDIR}"/${P}-musl-includes.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/860447
	#
	# Upstream is dead. The last release was in 2013 and the last maintainer
	# comment on discussions was 2020.
	filter-lto

	tc-export PKG_CONFIG

	append-cflags -fcommon
	econf \
		--disable-static \
		--disable-version-check \
		$(use_enable alsa) \
		$(use_enable oss)
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	default
	dodoc HOWTO

	find "${ED}" -name '*.la' -delete || die
}
