# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Generic framework for C development - used by the Icecast project"
HOMEPAGE="https://gitlab.xiph.org/xiph/icecast-libigloo/"
SRC_URI="https://downloads.xiph.org/releases/igloo/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="app-crypt/rhash:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# lto mismatch, see https://gitlab.xiph.org/xiph/icecast-libigloo/-/issues/7
	filter-lto
	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
