# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Command-line tools and server to remotely administer multiple Unix filesystems"
HOMEPAGE="https://github.com/Radmind https://sourceforge.net/projects/radmind/"
SRC_URI="https://github.com/voretaq7/radmind/releases/download/${P}/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}
	!dev-util/repo"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-gentoo.patch
	"${FILESDIR}"/${PN}-1.14.1-glibc225.patch
)

src_install() {
	default
	keepdir /var/radmind/{cert,client,postapply,preapply}
}
