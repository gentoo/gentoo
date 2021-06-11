# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/${PN}"
EGIT_COMMIT="4a7436442837da72f9e211d99f0145dff3246b66"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A tool to scrape a Prometheus client and dump the result as JSON"
HOMEPAGE="https://github.com/prometheus/prom2json"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${EGIT_COMMIT:0:7}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix ${PN} || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin ${PN}/${PN}
	dodoc {README,CONTRIBUTING}.md
	popd || die
}
