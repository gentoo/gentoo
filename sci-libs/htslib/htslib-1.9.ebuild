# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C library for high-throughput sequencing data formats"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="mirror://sourceforge/samtools/${PV}/${P}.tar.bz2"

SLOT="0/2"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+bzip2 curl +lzma static-libs"

RDEPEND="
	bzip2? ( app-arch/bzip2:= )
	curl? ( net-misc/curl )
	lzma? ( app-arch/xz-utils:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# upstream injects LDFLAGS into the .pc file,
	# which is a big nono for QA
	sed 's/private_LIBS=$LDFLAGS/private_LIBS=""/g' -i configure || die
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

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.a' -delete || die
	fi
}
