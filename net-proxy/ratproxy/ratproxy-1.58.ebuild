# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic

DESCRIPTION="A semi-automated, largely passive web application security audit tool"
HOMEPAGE="https://code.google.com/p/ratproxy/"
SRC_URI="https://ratproxy.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "s:keyfile\.pem:/usr/share/${PN}/&:" ssl.c
	sed -r -i -e "s:(ratproxy-back\.png|messages\.list):/usr/share/${PN}/&:" ratproxy-report.sh
	epatch "${FILESDIR}"/${PN}-Makefile.patch
}

src_compile() {
	tc-export CC

	emake || die "emake failed"
}

src_install() {
	dobin ${PN}-report.sh || die "install failed"
	dobin ${PN} || die "install failed"
	dodoc doc/{README,TODO}
	insinto /usr/share/${PN}
	doins keyfile.pem ratproxy-back.png messages.list
}
