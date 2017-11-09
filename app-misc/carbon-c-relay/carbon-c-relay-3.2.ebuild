# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Enhanced C version of Carbon relay, aggregator and rewriter"
HOMEPAGE="https://github.com/grobian/carbon-c-relay"
SRC_URI="https://github.com/grobian/carbon-c-relay/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="lz4 ssl zlib"

RDEPEND="lz4? ( app-arch/lz4 )
	ssl? ( dev-libs/openssl:0 )
	zlib? ( app-arch/gzip )"
DEPEND="${RDEPEND}"

pkg_preinst() {
	enewgroup carbon
	enewuser carbon -1 -1 -1 carbon
}

src_configure() {
	econf $(use_with lz4) $(use_with ssl) $(use_with zlib gzip)
}

src_install() {
	default
	# rename too generic name
	mv "${ED}"/usr/bin/{relay,${PN}} || die
	dodoc ChangeLog.md

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
}
