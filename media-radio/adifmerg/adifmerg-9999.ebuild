# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A small conversion and check utility for ADIF files"
HOMEPAGE="https://github.com/oh7bf/adifmerg"

inherit git-r3
EGIT_REPO_URI="https://github.com/oh7bf/adifmerg.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"

RDEPEND="dev-lang/perl"

src_install() {
	dobin adifmerg
	doman doc/adifmerg.1
	dodoc CHANGELOG README.md

	if use examples; then
		insinto /usr/share/${PN}
		doins -r script
	fi
}
