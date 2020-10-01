# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="gitlab.com/gitlab-org/${PN}/..."
EGIT_COMMIT="207b308c12b1717c6e3d2adf5e1ffe504c64f56e"

EGO_VENDOR=( "gopkg.in/yaml.v2 a3f3340b5840cee44f372bddb5880fcbc419b46a github.com/go-yaml/yaml" )

inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN%/*}/repository/archive.tar.gz?ref=${EGIT_COMMIT} -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Clean all old container revisions from registry"
HOMEPAGE="https://gitlab.com/gitlab-org/docker-distribution-pruner"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="MIT"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src || die
	GOPATH="${WORKDIR}/${P}" go install gitlab.com/gitlab-org/docker-distribution-pruner || die
	popd || die
}

src_install() {
	dobin bin/${PN}
}
