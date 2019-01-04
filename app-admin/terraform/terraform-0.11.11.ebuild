# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

DESCRIPTION="A tool for building, changing, and combining infrastructure safely"
HOMEPAGE="https://www.terraform.io/"

EGO_PN="github.com/hashicorp/${PN}"
ARCHIVE_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

SRC_URI="${ARCHIVE_URI}"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build \
		-v -ldflags="-s -w -X main.GitCommit=${PV}-gentoo" \
		-o build/_output/bin/terraform ./ || die
	popd
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin build/_output/bin/${PN} || die
	popd
}
