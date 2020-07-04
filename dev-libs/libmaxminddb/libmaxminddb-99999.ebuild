# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="C library for the MaxMind DB file format"
HOMEPAGE="https://github.com/maxmind/libmaxminddb"
EGIT_REPO_URI="https://github.com/maxmind/libmaxminddb.git"

LICENSE="Apache-2.0"
SLOT="0/0.0.7"
KEYWORDS=""
IUSE="static-libs"

DOCS=( Changes.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
