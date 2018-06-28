# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Validation tool for tinydns-data zone files"
SRC_URI="https://x42.com/software/valtz/${PN}.tgz"
HOMEPAGE="https://x42.com/software/valtz/"
IUSE=""

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

src_install() {
	dobin valtz
	dodoc README CHANGES
}
