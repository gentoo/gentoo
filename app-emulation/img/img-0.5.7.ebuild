# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/genuinetools/img"
GIT_COMMIT="d14bb92b69804443263d647647b0833013b8df91"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Standalone daemon-less unprivileged Dockerfile and OCI container image builder"
HOMEPAGE="https://github.com/genuinetools/img"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT"
SLOT="0"
IUSE="seccomp"

RESTRICT="test"

src_compile() {
	local TAGS=$(usex seccomp 'seccomp' '')
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -mod vendor -tags "noembed ${TAGS}" -v -ldflags "-X ${EGO_PN}/version.GITCOMMIT=${GIT_COMMIT} -X ${EGO_PN}/version.VERSION=${PV}" -o "${S}"/bin/img . || die
	popd || die
}

src_install() {
	dobin bin/*
	dodoc -r src/${EGO_PN}/README.md
}
