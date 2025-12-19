# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Distributed Shell"
HOMEPAGE="http://www.netfort.gr.jp/~dancer/software/dsh.html.en"
SRC_URI="http://www.netfort.gr.jp/~dancer/software/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

DEPEND="dev-libs/libdshconfig"
RDEPEND="${DEPEND}
	virtual/ssh
"

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/dsh
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodir /etc/dsh/group
}
