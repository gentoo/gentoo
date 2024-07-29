# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool to edit C strings in compiled binaries"
HOMEPAGE="http://ohnopub.net/~ohnobinki/bin_replace_string"
SRC_URI="ftp://mirror.ohnopub.net/mirror/${P}.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

RDEPEND="virtual/libelf:0"
DEPEND="${RDEPEND}"
BDEPEND="app-text/txt2man"

src_configure() {
	econf --enable-doc
}
