# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A modern HTTP benchmarking tool"
HOMEPAGE="https://github.com/wg/wrk"
SRC_URI="https://github.com/wg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/openssl:0 >=dev-lang/luajit-2.0.2"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -rf deps/luajit || die "failed to remove bundled luajit"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin wrk
	dodoc README NOTICE
	insinto /usr/share/${PN}
	doins -r scripts
}
