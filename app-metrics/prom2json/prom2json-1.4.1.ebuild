# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module edo

GIT_COMMIT=e76e84858a35a1094458b792c631cb75867fd550

DESCRIPTION="A tool to scrape a Prometheus client and dump the result as JSON"
HOMEPAGE="https://github.com/prometheus/prom2json"
SRC_URI="https://github.com/prometheus/prom2json/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-metrics/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i .promu.yml \
		-e "s/{{.Revision}}/${GIT_COMMIT}/" \
		-e "s/{{.Version}}/${PV}/" || die
}

src_compile() {
	mkdir bin || die
	edo promu build --prefix bin
}

src_test() {
	emake test-flags= test
}

src_install() {
	dobin bin/*
	dodoc {README,CONTRIBUTING}.md
}
