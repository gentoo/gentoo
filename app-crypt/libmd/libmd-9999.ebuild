# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal git-r3

DESCRIPTION="Message Digest functions from BSD systems"
HOMEPAGE="https://www.hadrons.org/software/libmd/"
EGIT_REPO_URI="https://git.hadrons.org/git/libmd.git"

LICENSE="|| ( BSD BSD-2 ISC BEER-WARE public-domain )"
SLOT="0"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
