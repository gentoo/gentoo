# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command-line trash can emulation"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="ftp://www.iq-computing.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-lang/perl"

DOCS=( README.txt )

src_install() {
	newbin ${PN}.pl ${PN}
}
