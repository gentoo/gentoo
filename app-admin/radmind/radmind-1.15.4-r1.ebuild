# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Command-line tools and server to remotely administer multiple Unix filesystems"
HOMEPAGE="https://github.com/Radmind https://sourceforge.net/projects/radmind/"
SRC_URI="https://github.com/voretaq7/radmind/releases/download/${P}/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pam zlib"

DEPEND="
	dev-libs/openssl:0=
	net-libs/libnsl
	pam? ( sys-libs/pam )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-gentoo.patch
	"${FILESDIR}"/${PN}-1.14.1-glibc225.patch
	# 779664
	"${FILESDIR}"/${PN}-1.15.4-autoreconf.patch
	"${FILESDIR}"/${PN}-1.15.4-autoreconf-libsnet.patch
)

src_prepare() {
	default

	# We really don't want these
	# https://github.com/Radmind/radmind/pull/336
	# https://sourceforge.net/p/libsnet/patches/7/
	rm -f {,libsnet/}aclocal.m4 || die

	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable pam)
		$(use_enable zlib)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	keepdir /var/radmind/{cert,client,postapply,preapply}
}
