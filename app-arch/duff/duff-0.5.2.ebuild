# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Command-line utility for quickly finding duplicates in a given set of files"
HOMEPAGE="http://duff.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	default
	dodoc HACKING
}
