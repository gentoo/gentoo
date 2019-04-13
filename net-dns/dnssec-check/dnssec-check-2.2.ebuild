# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

DESCRIPTION="Tests local resolver for support of DNSSEC validation"
HOMEPAGE="https://www.dnssec-tools.org"
SRC_URI="https://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtdeclarative:5
	net-dns/dnssec-validator[threads]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e '/Exec=/s:/opt::' -i ${PN}.desktop || die
}

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}/usr" install

	doicon ${PN}.png
	domenu ${PN}.desktop
}
