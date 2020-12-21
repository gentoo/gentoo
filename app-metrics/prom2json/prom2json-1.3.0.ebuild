# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
GIT_COMMIT=9180c89ee65bde2cbbe799d06d7d09e30f629984

DESCRIPTION="A tool to scrape a Prometheus client and dump the result as JSON"
HOMEPAGE="https://github.com/prometheus/prom2json"
SRC_URI="https://github.com/prometheus/prom2json/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

BDEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i \
		-e "s/{{.Revision}}/${GIT_COMMIT}/" \
		-e "s/{{.Version}}/${PV}/" \
		.promu.yml || die
}

src_compile() {
	mkdir bin || die
	promu build --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc {README,CONTRIBUTING}.md
}
