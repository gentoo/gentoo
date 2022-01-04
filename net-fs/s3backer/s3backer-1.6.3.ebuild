# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="FUSE-based single file backing store via Amazon S3"
HOMEPAGE="https://github.com/archiecobbs/s3backer"
SRC_URI="https://github.com/archiecobbs/s3backer/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/expat
	dev-libs/openssl:0=
	net-misc/curl
	sys-fs/fuse:0
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -e "/docdir=/s:packages/\$(PACKAGE):${PF}:" \
		-e "/doc_DATA=/d" \
		-i Makefile.am || die

	eautoreconf
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}
