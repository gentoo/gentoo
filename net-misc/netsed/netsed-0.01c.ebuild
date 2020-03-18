# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Small tool for altering forwarded network data in real time"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://lcamtuf.coredump.cx/soft/obsolete/netsed.tgz -> ${P}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}/${P}-man.patch"
)

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin netsed
	doman debian/netsed.1
	dodoc README
}
