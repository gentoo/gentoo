# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="dnswalk is a DNS database debugger"
HOMEPAGE="https://sourceforge.net/projects/dnswalk/"
SRC_URI="mirror://sourceforge/dnswalk/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-perl/Net-DNS-0.12"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${PN}-2.0.2-portable-shebang.patch )

src_install() {
	dobin dnswalk

	einstalldocs
	dodoc do-dnswalk makereports sendreports rfc1912.txt dnswalk.errors
	doman dnswalk.1
}
