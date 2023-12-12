# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Monitors a given set of directories for new files"
HOMEPAGE="https://github.com/l3ib/fsniper"
SRC_URI="http://projects.l3ib.org/${PN}/files/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/libpcre
	sys-apps/file"

RDEPEND="
	${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-umask.patch
	"${FILESDIR}"/${P}-waitpid.patch
)

DOCS=( AUTHORS COPYING NEWS README example.conf )

src_prepare() {
	default
	eautoreconf
}
