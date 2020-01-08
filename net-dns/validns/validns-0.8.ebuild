# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="A high performance DNS/DNSSEC zone validator"
HOMEPAGE="http://www.validns.net/"
SRC_URI="http://www.validns.net/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/judy"
DEPEND="
	${RDEPEND}
	test? ( dev-perl/Test-Command-Simple )
"

src_install() {
	dobin validns
	doman validns.1
	dodoc {notes,technical-notes,todo,usage}.mdwn Changes README
}
