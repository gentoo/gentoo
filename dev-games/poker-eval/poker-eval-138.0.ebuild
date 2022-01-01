# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A fast C library for evaluating poker hands"
HOMEPAGE="http://gna.org/projects/pokersource/"
SRC_URI="http://download.gna.org/pokersource/sources/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( AUTHORS ChangeLog NEWS README TODO WHATS-HERE )

src_configure() {
	econf \
		--without-ccache \
		--disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
