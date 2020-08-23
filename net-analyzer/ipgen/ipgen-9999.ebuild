# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="Generate list of IP addresses from a network specification"
HOMEPAGE="https://github.com/royhills/ipgen"
EGIT_REPO_URI="https://github.com/royhills/ipgen"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

src_prepare() {
	default
	eautoreconf
}
