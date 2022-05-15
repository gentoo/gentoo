# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
EGIT_COMMIT=b1a2edae78614c8b0ae9e2faa88d14098e96f6d2

DESCRIPTION="Prometheus Utility Tool"
HOMEPAGE="https://github.com/prometheus/promu"
SRC_URI="https://github.com/prometheus/promu/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE=""

RESTRICT+=" test"

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${EGIT_COMMIT}/" .promu.yml || die
}

src_compile() {
	ego build .
}

src_install() {
	dobin ${PN}
	dodoc -r {doc,{README,CONTRIBUTING}.md}
}
