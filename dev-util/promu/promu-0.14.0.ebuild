# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
EGIT_COMMIT=a880d9756ae466605040585bc3b15005b55cc9f6

DESCRIPTION="Prometheus Utility Tool"
HOMEPAGE="https://github.com/prometheus/promu"
SRC_URI="https://github.com/prometheus/promu/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~xen0n/distfiles/dev-util/promu/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
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
