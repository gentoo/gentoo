# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="C library for high-throughput sequencing data formats"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="https://github.com/samtools/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0/3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+bzip2 curl +lzma"

RDEPEND="
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	curl? ( net-misc/curl )
	lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# upstream injects LDFLAGS into the .pc file,
	# which is a big nono for QA
	sed -e '/^\(static_l\|Libs.private\|Requires.private\)/d' \
		-i htslib.pc.in || die
}

src_configure() {
	econf \
		--disable-gcs \
		--disable-plugins \
		--disable-s3 \
		$(use_enable bzip2 bz2) \
		$(use_enable curl libcurl) \
		$(use_enable lzma)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	# doesn't use libtool, can't disable static libraries
	find "${ED}" -name '*.a' -delete || die
}
