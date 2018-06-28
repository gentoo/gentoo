# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/genuinetools/img"
EGIT_COMMIT="v${PV}"
GIT_COMMIT="e4a43d044778e3df56e0de3c6ca00706fcca8b50"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Tool to move from docker-compose to Kubernetes"
HOMEPAGE="https://github.com/kubernetes/kompose https://kompose.io"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="seccomp"

RESTRICT="test"

src_compile() {
	local TAGS=$(usex seccomp 'seccomp' '')
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -tags ${TAGS} -v -ldflags "-X ${EGO_PN}/version.GITCOMMIT=${GIT_COMMIT} -X ${EGO_PN}/version.VERSION=${PV}" -o "${S}"/bin/img . || die
	popd || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN}/README.md
}
