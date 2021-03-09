# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Message Digest functions from BSD systems"
HOMEPAGE="https://www.hadrons.org/software/libmd/"
EGIT_REPO_URI="https://git.hadrons.org/git/libmd.git"

LICENSE="|| ( BSD BSD-2 ISC BEER-WARE public-domain )"
SLOT="0"

src_prepare() {
	default
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
