# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Library for Japanese pTeX providing a better way of handling character encodings"
HOMEPAGE="http://tutimura.ath.cx/ptexlive/?ptexenc"
SRC_URI="https://mirrors.ctan.org/systems/texlive/Source/texlive-${PV#*_p}-source.tar.xz"
S="${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos"
IUSE="iconv"

DEPEND="
	dev-libs/kpathsea:=
	iconv? ( virtual/libiconv )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# https://bugs.gentoo.org/show_bug.cgi?id=377141
	sed -i '/^LIBS/s:@LIBS@:@LIBS@ @KPATHSEA_LIBS@:' Makefile.in || die

	cd "${WORKDIR}/texlive-${PV#*_p}-source" || die
	S="${WORKDIR}/texlive-${PV#*_p}-source" elibtoolize #sane .so versionning on gfbsd
}

src_configure() {
	econf \
		--disable-static \
		--with-system-kpathsea \
		$(use_enable iconv kanji-iconv)
}

src_install() {
	default

	insinto /usr/include/ptexenc
	doins ptexenc/unicode-jp.h
	use iconv && doins ptexenc/kanjicnv.h

	find "${ED}" -name '*.la' -delete || die
}
