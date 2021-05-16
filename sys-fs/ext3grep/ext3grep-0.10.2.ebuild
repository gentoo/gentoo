# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Recover deleted files on an ext3 file system"
HOMEPAGE="https://code.google.com/p/ext3grep/"
SRC_URI="https://ext3grep.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug pch"

DEPEND="sys-fs/e2fsprogs
	virtual/os-headers
	virtual/pkgconfig"

DOCS="NEWS README"

PATCHES=(
	"${FILESDIR}/${PN}-0.10.1-gcc44.patch"
	"${FILESDIR}/${P}-include-unistd_h-for-sysconf.patch"
	"${FILESDIR}/${P}-new-e2fsprogs.patch"
	"${FILESDIR}/${P}-newer-e2fsprogs.patch"
)

src_configure() {
	myeconfargs=(
		$(use_enable debug)
		$(use_enable pch)
	)

	econf "${myeconfargs[@]}"
}
