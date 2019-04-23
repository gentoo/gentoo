# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic

DESCRIPTION="The dnsproxy daemon is a proxy for DNS queries"
HOMEPAGE="https://www.wolfermann.org/dnsproxy.html"
SRC_URI="https://www.wolfermann.org/${P}.tar.gz"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/libevent
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.16-include.patch
)

src_compile() {
	append-cppflags -D_GNU_SOURCE
	emake ${PN}
}

src_install() {
	dosbin ${PN}
	keepdir /var/empty

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	insinto /etc/${PN}
	newins ${PN}.conf ${PN}.conf.dist

	dodoc README
	doman ${PN}.1
}
