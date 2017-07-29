# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="https://github.com/scarabeusiv/ucpp.git"
inherit eutils git-2 autotools

DESCRIPTION="A quick and light preprocessor, but anyway fully compliant to C99"
HOMEPAGE="https://github.com/scarabeusiv/ucpp"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files --all
}
