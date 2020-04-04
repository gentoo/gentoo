# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="gopkg.in/Netflix-Skunkworks/go-jira.v1"

inherit golang-build golang-vcs-snapshot

KEYWORDS="amd64"

DESCRIPTION="A simple JIRA commandline client in Go"
HOMEPAGE="https://github.com/Netflix-Skunkworks/go-jira"
SRC_URI="https://github.com/Netflix-Skunkworks/go-jira/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 BSD-2 BSD ISC MIT MIT-with-advertising"
SLOT="0"
IUSE=""

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${WORKDIR}/${P}" go build -v -o jira  cmd/jira/main.go || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/jira
	dodoc src/${EGO_PN}/{CHANGELOG,README}.md
}
