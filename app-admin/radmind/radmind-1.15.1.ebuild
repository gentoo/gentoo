# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Command-line tools and server to remotely administer multiple Unix filesystems"
HOMEPAGE="https://github.com/Radmind https://sourceforge.net/projects/radmind/"
SRC_URI="https://github.com/voretaq7/radmind/releases/download/${P}/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libressl"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
"
RDEPEND="${DEPEND}
	!dev-util/repo
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-gentoo.patch
	"${FILESDIR}"/${PN}-1.14.1-glibc225.patch
)

src_configure() {
	append-cflags -fcommon
	default
}

src_install() {
	default
	keepdir /var/radmind/{cert,client,postapply,preapply}
}
