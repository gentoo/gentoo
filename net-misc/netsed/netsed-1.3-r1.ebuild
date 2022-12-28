# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small tool for altering forwarded network data in real time"
HOMEPAGE="http://silicone.homelinux.org/projects/netsed/"
SRC_URI="http://silicone.homelinux.org/release/netsed/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-lang/ruby )"

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin netsed
	dodoc NEWS README
}
