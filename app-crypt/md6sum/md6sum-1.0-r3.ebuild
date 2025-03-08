# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A C implementation of MD6"
HOMEPAGE="https://groups.csail.mit.edu/cis/md6"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-format-security.patch"
)

src_configure() {
	append-cflags -fcommon # bug #706780
	default
}
