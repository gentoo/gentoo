# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="FUSE-based single file backing store via Amazon S3"
HOMEPAGE="https://code.google.com/p/s3backer"
SRC_URI="https://s3backer.googlecode.com/files/s3backer-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-misc/curl
	sys-fs/fuse
	sys-libs/zlib
	dev-libs/expat
	dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "/docdir=/s:packages/\$(PACKAGE):${PF}:" \
		-e "/doc_DATA=/d" \
		-i Makefile.am || die

	eautoreconf
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}
