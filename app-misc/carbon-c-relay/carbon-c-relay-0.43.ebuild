# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/carbon-c-relay/carbon-c-relay-0.43.ebuild,v 1.1 2015/07/27 16:57:51 grobian Exp $

EAPI=5

inherit toolchain-funcs user

DESCRIPTION="Enhanced C version of Carbon relay, aggregator and rewriter"
HOMEPAGE="https://github.com/grobian/carbon-c-relay"
SRC_URI="https://github.com/grobian/carbon-c-relay/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

pkg_preinst() {
	enewgroup carbon
	enewuser carbon -1 -1 -1 carbon
}

src_prepare() {
	tc-export CC
	tc-has-openmp || export OPENMP_FLAGS=
}

src_install() {
	newbin relay ${PN}
	dodoc README.md

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
