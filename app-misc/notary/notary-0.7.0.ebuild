# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
GIT_COMMIT=b0b6bfdd

DESCRIPTION="A project that allows anyone to have trust over arbitrary collections of data"
HOMEPAGE="https://github.com/theupdateframework/notary"
SRC_URI="https://github.com/theupdateframework/notary/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/notary
	acct-user/notary
"
BDEPEND="${RDEPEND}"

src_compile() {
	emake GITCOMMIT=${GIT_COMMIT} NOTARY_VERSION=${PV} binaries
}

src_install() {
	dobin bin/${PN}{,-server,-signer}
	insinto /var/lib/notary
	doins -r migrations fixtures
	fowners -R ${PN}:${PN} /var/lib/notary
	fperms -R 0600 /var/lib/notary/fixtures/database/
	newinitd "${FILESDIR}"/notary-signer.initd notary-signer
	newconfd "${FILESDIR}"/notary-signer.confd notary-signer
	newinitd "${FILESDIR}"/notary-server.initd notary-server
	newconfd "${FILESDIR}"/notary-server.confd notary-server
}
