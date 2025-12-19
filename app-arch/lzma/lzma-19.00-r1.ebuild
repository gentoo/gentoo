# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs unpacker

MY_P="${PN}${PV//.}"
DESCRIPTION="LZMA Stream Compressor from the SDK"
HOMEPAGE="https://www.7-zip.org/sdk.html"
SRC_URI="https://downloads.sourceforge.net/sevenzip/${MY_P}.7z -> ${P}.7z"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
IUSE="doc"

BDEPEND="$(unpacker_src_uri_depends)"

S=${WORKDIR}

src_compile() {
	cd CPP/7zip/Bundles/LzmaCon || die
	emake -f makefile.gcc \
		CXX="$(tc-getCXX) ${CXXFLAGS} ${CPPFLAGS}" \
		CXX_C="$(tc-getCC) ${CFLAGS} ${CPPFLAGS}"
}

src_install() {
	newbin CPP/7zip/Bundles/LzmaCon/lzma lzmacon
	dodoc DOC/lzma.txt DOC/lzma-history.txt
	use doc && dodoc DOC/7zC.txt \
		DOC/7zFormat.txt \
		DOC/Methods.txt  \
		DOC/lzma-sdk.txt \
		DOC/lzma-specification.txt
}

pkg_postinst() {
	einfo "The lzma binary is now 'lzmacon' to avoid xz-utils conflicts #218459"
}
