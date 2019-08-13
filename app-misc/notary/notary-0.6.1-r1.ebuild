# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot golang-build user

KEYWORDS="~amd64"
DESCRIPTION="A project that allows anyone to have trust over arbitrary collections of data"
EGO_PN="github.com/theupdateframework/notary"
GIT_COMMIT="d6e1431feb32348e0650bf7551ac5cffd01d857b"

HOMEPAGE="https://github.com/theupdateframework/notary"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH=${S} go install -v -tags pkcs11 -ldflags "-w -X ${EGO_PN}/version.GitCommit=${GIT_COMMIT} -X ${EGO_PN}/version.NotaryVersion=${PV}" \
		${EGO_PN}/cmd/notary-server || die
	GOPATH=${S} go install -v -tags pkcs11 -ldflags "-w -X ${EGO_PN}/version.GitCommit=${GIT_COMMIT} -X ${EGO_PN}/version.NotaryVersion=${PV}" \
		${EGO_PN}/cmd/notary-signer || die
	GOPATH=${S} go install -v -tags pkcs11 -ldflags "-w -X ${EGO_PN}/version.GitCommit=${GIT_COMMIT} -X ${EGO_PN}/version.NotaryVersion=${PV}" \
		${EGO_PN}/cmd/notary || die
	popd || die
}

src_install() {
	dobin bin/${PN}{,-server,-signer}
	pushd src/${EGO_PN} || die
	insinto /var/lib/notary
	doins -r migrations fixtures
	fowners -R ${PN}:${PN} /var/lib/notary
	fperms -R 0600 /var/lib/notary/fixtures/database/
	newinitd "${FILESDIR}"/notary-signer.initd notary-signer
	newconfd "${FILESDIR}"/notary-signer.confd notary-signer
	newinitd "${FILESDIR}"/notary-server.initd notary-server
	newconfd "${FILESDIR}"/notary-server.confd notary-server
}
