# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Filesystem Integrity Checker"
SRC_URI="mirror://sourceforge/petrovich/${P}.tar.gz"
HOMEPAGE="https://sourceforge.net/projects/petrovich"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc ~sparc"

RDEPEND="virtual/perl-Digest-MD5"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/${P}-gentoo.diff" )
HTML_DOCS=( CHANGES.HTML LICENSE.HTML README.HTML TODO.HTML USAGE.HTML )

src_install() {
	dosbin "${PN}.pl"

	insinto /etc
	doins "${FILESDIR}/${PN}.conf"

	dodir "/var/db/${PN}"

	einstalldocs
}
