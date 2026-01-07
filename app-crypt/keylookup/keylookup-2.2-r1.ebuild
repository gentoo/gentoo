# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A tool to fetch PGP keys from keyservers"
HOMEPAGE="http://www.palfrader.org/keylookup/"
SRC_URI="http://www.palfrader.org/keylookup/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	dev-lang/perl
	app-crypt/gnupg"

src_install() {
	dobin keylookup
	doman keylookup.1
	einstalldocs
}
