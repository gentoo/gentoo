# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/-}

DESCRIPTION="A small conversion and check utility for ADIF files"
HOMEPAGE="https://github.com/oh7bf/adifmerg"
SRC_URI="http://www.saunalahti.fi/~jaakoive/Soft/${MY_P}.tgz"

S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

RDEPEND="dev-lang/perl"

src_install() {
	dobin adifmerg
	doman doc/adifmerg.1
	dodoc CHANGELOG README

	if use examples; then
		insinto /usr/share/${PN}
		doins -r script
	fi
}
