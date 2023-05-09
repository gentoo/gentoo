# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Filesystem Integrity Checker"
HOMEPAGE="https://sourceforge.net/projects/petrovich"
SRC_URI="mirror://sourceforge/petrovich/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="virtual/perl-Digest-MD5"

PATCHES=( "${FILESDIR}/${P}-gentoo.diff" )
HTML_DOCS=( CHANGES.HTML LICENSE.HTML README.HTML TODO.HTML USAGE.HTML )

src_install() {
	dosbin "${PN}.pl"

	insinto /etc
	doins "${FILESDIR}/${PN}.conf"

	dodir "/var/db/${PN}"

	einstalldocs
}
