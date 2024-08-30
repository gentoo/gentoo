# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A filesystem that contains a single file backed by Amazon S3"
HOMEPAGE="https://github.com/archiecobbs/s3backer"
SRC_URI="https://github.com/archiecobbs/s3backer/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nbd"

RDEPEND="
	app-arch/zstd:=
	dev-libs/expat
	dev-libs/openssl:0=
	net-misc/curl
	sys-fs/fuse:0
	sys-libs/zlib
	nbd? ( sys-block/nbd sys-block/nbdkit )
"
DEPEND="${RDEPEND}
	elibc_musl? ( sys-libs/queue-standalone )
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	sed -e "/docdir=/s:packages/\$(PACKAGE):${PF}:" \
		-e "/doc_DATA=/d" \
		-i Makefile.am || die

	eautoreconf
}

src_configure() {
	econf $(use_enable nbd)
}

src_install() {
	default

	if use nbd ; then
		rm "${ED}/usr/$(get_libdir)/nbdkit/plugins/nbdkit-s3backer-plugin.la" || die
	fi
}
