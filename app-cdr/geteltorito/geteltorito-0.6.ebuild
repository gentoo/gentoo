# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="El Torito boot image extractor"
HOMEPAGE="https://userpages.uni-koblenz.de/~krienke/"
SRC_URI="https://userpages.uni-koblenz.de/~krienke/ftp/noarch/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-lang/perl"

S="${WORKDIR}/${PN}"

src_install() {
	dobin geteltorito
	dodoc README
}
